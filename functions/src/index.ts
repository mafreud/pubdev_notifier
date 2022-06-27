/* eslint-disable @typescript-eslint/no-unused-vars */
import * as functions from "firebase-functions";
import admin = require("firebase-admin");
import {info, warn} from "firebase-functions/lib/logger";


// eslint-disable-next-line @typescript-eslint/no-var-requires
const axios = require("axios").default;
admin.initializeApp();

export const updatePackages = functions.pubsub.schedule("0 9 * * *").timeZone("Asia/Tokyo").onRun(async (context) => {
  const targetPackage = "cloud_firestore";
  const pubDevVersion = await getPackageVersionFromPubDev(targetPackage);
  const firestoreVersion = await getPackageVersionFromFirestore(targetPackage);

  if (pubDevVersion==firestoreVersion) {
    info("no update");
  } else {
    info("update is available");
    // 1. send push notification.
    // 2. update package version on firestore
    updatePackageVersionOnFirestore(targetPackage, pubDevVersion);
  }
});


async function getPackageVersionFromPubDev(packageName:string) {
  const packageUrl = `https://pub.dev/api/packages/${packageName}`;
  const response = await axios.get(packageUrl);
  info("Logs", response.data);
  info(`${packageName} version`, response.data["latest"]["version"]);
  return response.data["latest"]["version"];
}

async function getPackageVersionFromFirestore(packageName:string) {
  const firebase = admin.firestore();
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
