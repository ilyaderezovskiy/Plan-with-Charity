import firebase from 'firebase'
require('firebase/auth')
require('firebase/firestore')
require('firebase/storage')

// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyDExrs3Vpn2kAK9miLp4-CWCJrkekT9oUo",
  authDomain: "disney-api-app.firebaseapp.com",
  projectId: "disney-api-app",
  storageBucket: "disney-api-app.appspot.com",
  messagingSenderId: "1093804232871",
  appId: "1:1093804232871:web:86eb21f357eadd63f60b82"
};

let app;
if (firebase.apps) {
  if (firebase.apps.length === 0) {
    app = firebase.initializeApp(firebaseConfig);
  } else {
    app = firebase.app()
  }
}

const auth = firebase.auth()

export { auth };