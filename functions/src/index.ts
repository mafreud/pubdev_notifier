/* eslint-disable @typescript-eslint/no-unused-vars */
import * as functions from "firebase-functions";
import admin = require("firebase-admin");
import {info, warn} from "firebase-functions/lib/logger";
import * as firebaseAdmin from "firebase-admin";


firebaseAdmin.initializeApp({
  credential: firebaseAdmin.credential.cert({
    projectId: "pubdev-notifier",
    clientEmail: `${process.env.CLIENT_EMAIL}`,
    privateKey: `${process.env.PRIVATE_KEY}`,
  }),
});

// eslint-disable-next-line @typescript-eslint/no-var-requires
const axios = require("axios").default;
const firebase = admin.firestore();

export const updatePackages = functions.pubsub.schedule("0 9 * * *").timeZone("Asia/Tokyo").onRun(async (context) => {
  const packageList = ["cloud_firestore", "firebase_core", "firebase_auth", "go_router"];
  for await (const targetPackage of packageList) {
    await update(targetPackage);
  }
});

async function update(targetPackage:string) {
  const pubDevVersion = await getPackageVersionFromPubDev(targetPackage);
  const firestoreVersion = await getPackageVersionFromFirestore(targetPackage);

  if (pubDevVersion==firestoreVersion) {
    info("no update");
  } else {
    info("update is available");
    await sendPushNotification(targetPackage, pubDevVersion);
    await updatePackageVersionOnFirestore(targetPackage, pubDevVersion);
  }
}

async function sendPushNotification(targetPackage:string, pubDevVersion:string) {
  const userQs = await firebase.collection("user").get();
  const tokens: string[] = [];
  for await (const userDocs of userQs.docs) {
    const fcmTokenDocs = await firebase.collection("user").doc(userDocs.id).collection("fcmToken").doc("fcmToken").get();
    const fcmData = fcmTokenDocs.data();
    info("fcmData", fcmData);
    if (fcmData==undefined) {
      return null;
    }
    const {fcmToken} =fcmData;

    if (fcmToken == "") {
      info("fcmToken is not set. This functions is finishing.");
      return null;
    }
    tokens.push(fcmToken);
  }
  info("tokens:", tokens);
  const params = {
    notification: {
      title: "New version is released!",
      body: `${targetPackage} v${pubDevVersion}`,
    },
    tokens: tokens,
  };
  info("params:", params);
  try {
    const result = await firebaseAdmin.messaging().sendMulticast(params);
    info("result", result);
  } catch (e) {
    warn("erorr", e);
  }
  return null;
}


async function getPackageVersionFromPubDev(packageName:string) {
  const packageUrl = `https://pub.dev/api/packages/${packageName}`;
  const response = await axios.get(packageUrl);
  info("Logs", response.data);
  info(`${packageName} version`, response.data["latest"]["version"]);
  return response.data["latest"]["version"];
}

async function getPackageVersionFromFirestore(packageName:string) {
  const docs = await firebase.collection("package").doc(packageName).get();
  const data = docs.data();
  if (data === undefined) {
    warn("data is undefined", data);
    return;
  }
  info("Logs", data);
  const {version} = data;
  info(`${packageName} version`, version);
  return version;
}

async function updatePackageVersionOnFirestore(packageName:string, packageVersion:string) {
  const firebase = admin.firestore();
  const ref = firebase.collection("package").doc(packageName);
  const result = await ref.update({"version": packageVersion});
  info("update completed:", result);
}
