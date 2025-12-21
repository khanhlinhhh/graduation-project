// Firebase configuration for Green Admin
// Using same project as the mobile app

import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';
import { getAuth } from 'firebase/auth';

const firebaseConfig = {
    apiKey: "AIzaSyAnG5vcOU8_7ZWvE-iEnciH5i8sBSngwAw",
    authDomain: "green-app-95926.firebaseapp.com",
    projectId: "green-app-95926",
    storageBucket: "green-app-95926.firebasestorage.app",
    messagingSenderId: "49958639886",
    appId: "1:49958639886:web:8c2db18d029db583f8df5f"
};

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
export const auth = getAuth(app);
export default app;
