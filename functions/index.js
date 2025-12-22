const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

/**
 * Triggered when a document is deleted from the 'users' collection.
 * Deletes the corresponding user from Firebase Authentication.
 */
exports.onUserDeleted = functions.firestore
    .document("users/{userId}")
    .onDelete(async (snap, context) => {
        const userId = context.params.userId;
        console.log(`Deleting user from Auth: ${userId}`);

        try {
            await admin.auth().deleteUser(userId);
            console.log(`Successfully deleted user ${userId} from Firebase Auth`);
        } catch (error) {
            // If the user is already deleted or not found, we can ignore the error
            if (error.code === "auth/user-not-found") {
                console.log(`User ${userId} not found in Auth, skipping.`);
                return;
            }
            console.error(`Error deleting user ${userId} from Auth:`, error);
        }
    });
