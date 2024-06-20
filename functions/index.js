
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.scheduleNotifications = functions.firestore
    .document('reminders/{reminderId}')
    .onCreate(async (snap, context) => {
        const reminder = snap.data();
        const reminderTitle = reminder.title;
        const reminderDate = reminder.valability.toDate();
        const userId = reminder.userId;

        const notificationDate1 = new Date(reminderDate);
        notificationDate1.setDate(notificationDate1.getDate() - 1);

        const notificationDate7 = new Date(reminderDate);
        notificationDate7.setDate(notificationDate7.getDate() - 7);

        const notificationDate18Hours = new Date(reminderDate);
        notificationDate18Hours.setHours(notificationDate18Hours.getHours() - 16);

        scheduleNotification(notificationDate1, reminderTitle, 'Emlékeztető 1 nappal korábban', userId);
        scheduleNotification(notificationDate7, reminderTitle, 'Emlékeztető 7 nappal korábban', userId);
        scheduleNotification(notificationDate18Hours, reminderTitle, 'Emlékeztető 18 órával korábban', userId);
    });

function scheduleNotification(scheduledDate, title, body, userId) {
    const message = {
        notification: {
            title: title,
            body: body,
        },
        token: userId,
    };

    const delayInMilliseconds = scheduledDate.getTime() - new Date().getTime();

    setTimeout(async () => {
        try {
            await admin.messaging().send(message);
            console.log('Notification sent successfully');
        } catch (error) {
            console.error('Error sending notification:', error);
        }
    }, delayInMilliseconds);
}
