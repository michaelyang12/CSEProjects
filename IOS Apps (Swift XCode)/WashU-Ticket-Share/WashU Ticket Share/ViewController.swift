import UIKit
import Firebase


class ViewController: UIViewController {
    
    var users: [String:User] = [:]
    var tickets: [String:Ticket] = [:]
    var messageRooms: [String: MessageRoom] = [:]
    var messages: [String: Message] = [:]
    var sentFromRating: Bool = false
    
    @IBOutlet weak var rating: RatingController!
    
    @IBAction func clickButtonRate(_ sender: Any) {
        let rating = rating.starsRating
//        print(rating)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let rootRef = Database.database().reference()
        
        let addUserRef = rootRef.child("users").childByAutoId()
        let addTicketRef = rootRef.child("tickets").childByAutoId()
        let addMessageRef = rootRef.child("messages").childByAutoId()
        let addMessageRoomRef = rootRef.child("message rooms").childByAutoId()
        
        
        
//        addUserRef.setValue(["email":"email@email.com", "name":"jonathan", "password": "pwd123", "rating": 3.0, "username":"username123"])
//        addTicketRef.setValue(["date listed": "date", "event date": "date", "event name": "name", "event time": "time", "price":50, "time listed": "time", "username posted": "user123"])
//        addMessageRoomRef.setValue(["last message date": "date", "last message time": "time", "user1": "username123", "user2": "username456"])
//        addMessageRef.setValue(["date sent": "date", "message text": "hi", "room id": "asdf", "time sent": "time", "user received": "user123", "user sent": "user456"])
        
//        rootRef.child("users").observe(.value, with: { snapshot in
//            if ( snapshot.value is NSNull ) {
//                print("not found")
//            } else {
//                var newUsers: [String:User] = [:]
//                for child in snapshot.children { //even though there is only 1 child
//
//                    let snap = child as! DataSnapshot
////                            print(snap.key)
////                    let dict = snap.value as! [String: Any]
////                    let name = dict["name"] as? String ?? ""
////                    let password = dict["password"] as? String ?? ""
////                    let email = dict["email"] as? String ?? ""
////                    let rating = dict["rating"] as? Double ?? 5.0
//
//                    newUsers[snap.key] = User(snapshot: snap)
//
//                }
//                self.users = newUsers
//            }
//        })
//
//        rootRef.child("tickets").observe(.value, with: { snapshot in
//            if ( snapshot.value is NSNull ) {
//                print("not found")
//            } else {
//                var newTickets: [String:Ticket] = [:]
//                for child in snapshot.children { //even though there is only 1 child
//
//                    let snap = child as! DataSnapshot
////                            print(snap.key)
////                    let dict = snap.value as! [String: Any]
////                    let name = dict["name"] as? String ?? ""
////                    let password = dict["password"] as? String ?? ""
////                    let email = dict["email"] as? String ?? ""
////                    let rating = dict["rating"] as? Double ?? 5.0
//
//                    newTickets[snap.key] = Ticket(snapshot: snap)
//
//                }
//                self.tickets = newTickets
//            }
//        })
//
//        rootRef.child("message rooms").observe(.value, with: { snapshot in
//            if ( snapshot.value is NSNull ) {
//                print("not found")
//            } else {
//                var newMessageRooms: [String:MessageRoom] = [:]
//                for child in snapshot.children { //even though there is only 1 child
//
//                    let snap = child as! DataSnapshot
////                            print(snap.key)
////                    let dict = snap.value as! [String: Any]
////                    let name = dict["name"] as? String ?? ""
////                    let password = dict["password"] as? String ?? ""
////                    let email = dict["email"] as? String ?? ""
////                    let rating = dict["rating"] as? Double ?? 5.0
//
//                    newMessageRooms[snap.key] = MessageRoom(snapshot: snap)
//
//                }
//                self.messageRooms = newMessageRooms
//            }
//        })
//
//        rootRef.child("messages").observe(.value, with: { snapshot in
//            if ( snapshot.value is NSNull ) {
//                print("not found")
//            } else {
//                var newMessages: [String:Message] = [:]
//                for child in snapshot.children { //even though there is only 1 child
//
//                    let snap = child as! DataSnapshot
////                            print(snap.key)
////                    let dict = snap.value as! [String: Any]
////                    let name = dict["name"] as? String ?? ""
////                    let password = dict["password"] as? String ?? ""
////                    let email = dict["email"] as? String ?? ""
////                    let rating = dict["rating"] as? Double ?? 5.0
//
//                    newMessages[snap.key] = Message(snapshot: snap)
//
//                }
//                self.messages = newMessages
//
//            }
//        })
        
        
    }
}

struct User: Codable {
//    var password: String
//    var name: String
//    var email: String
//    var rating: Double
//    var username: String
    var uid: String
    var name: String
    var rating: Double
    var transactions: Int
    
    init(uid: String, name: String, rating: Double, transactions:Int ) {

        self.uid = uid
        self.name = name
        self.rating = rating
        self.transactions = transactions

    }
    
//    init(snapshot: DataSnapshot) {
//
//        let snapshotValue = snapshot.value as! [String:AnyObject]
//
//        //self.email = snapshotValue["email"] as! String
//        self.uid = snapshotValue["uid"] as! String
//        self.name = snapshotValue["name"] as! String
//        //self.password = snapshotValue["password"] as! String
//        self.rating = snapshotValue["average rating"] as! Double
//        self.transactions = snapshotValue["number of successful transactions"] as! Int
//        //self.username = snapshotValue["username"] as! String
//    }
}

struct MessageRoom {
    var id: String
    var user1id: String
    var user1name: String
    var user2id: String
    var user2name: String
    var messages: [NSDictionary]
    
//    init(lastMessageDate: String, lastMessageTime: String, user1: String, user2:String ) {
//
//        self.lastMessageDate = lastMessageDate
//        self.lastMessageTime = lastMessageTime
//        self.user1 = user1
//        self.user2 = user2
//    }
    
    init(snapshot: DataSnapshot) {

        let snapshotValue = snapshot.value as! [String:AnyObject]

        self.id = snapshotValue["id"] as! String
        self.user1id = snapshotValue["user1id"] as! String
        self.user1name = snapshotValue["user1name"] as! String
        self.user2id = snapshotValue["user2id"] as! String
        self.user2name = snapshotValue["user2name"] as! String
        self.messages = snapshotValue["messages"] as! [NSDictionary]
    }
}

struct Message: Codable {
    var dateSent: String
    var messageText: String
    var roomID: String
    var timeSent: String
    var userReceivedID: String
    var userReceivedName: String
    var userSentID: String
    var userSentName: String
    
    init (dateSent: String, messageText: String, roomID: String, timeSent: String, userReceivedID: String, userReceivedName: String, userSentID: String, userSentName: String) {
        self.dateSent = dateSent
        self.messageText = messageText
        self.roomID = roomID
        self.timeSent = timeSent
        self.userReceivedID = userReceivedID
        self.userReceivedName = userReceivedName
        self.userSentID = userSentID
        self.userSentName = userSentName
    }
    
//    init(snapshot: DataSnapshot) {
//
//        let snapshotValue = snapshot.value as! [String:AnyObject]
//
//        self.dateSent = snapshotValue["date sent"] as! String
//        self.messageText = snapshotValue["message text"] as! String
//        self.roomID = snapshotValue["room id"] as! String
//        self.timeSent = snapshotValue["time sent"] as! String
//        self.userReceived = snapshotValue["user received"] as! User
//        self.userSent = snapshotValue["user sent"] as! User
//    }
}

struct Ticket: Codable {
    var dateListed: String
    var eventDate: String
    var eventName: String
    var price: String
    var userIdPosted: String
    var usernamePosted: String
    var sold: Bool
    var id: String
    
    init(snapshot: DataSnapshot) {

        self.id = snapshot.key
        let snapshotValue = snapshot.value as! [String:AnyObject]
        self.dateListed = snapshotValue["date listed"] as! String
        self.eventDate = snapshotValue["event date"] as! String
        self.eventName = snapshotValue["event name"] as! String
        self.price = snapshotValue["price"] as! String
        self.userIdPosted = snapshotValue["userid posted"] as! String
        self.usernamePosted = snapshotValue["username posted"] as! String
        self.sold = snapshotValue["sold"] as! Bool
    }
}

struct InboxItem: Codable {
    var buyerName: String
    var buyerID: String
    var sellerName: String
    var sellerID: String
    var nameOfEvent: String
    var dateOf: String
    var price: String
    var completed: Bool
    var id: String
    
    init(snapshot: DataSnapshot) {

        self.id = snapshot.key
        let snapshotValue = snapshot.value as! [String:AnyObject]
        self.buyerName = snapshotValue["buyerName"] as! String
        self.buyerID = snapshotValue["buyerID"] as! String
        self.sellerName = snapshotValue["sellerName"] as! String
        self.sellerID = snapshotValue["sellerID"] as! String
        self.nameOfEvent = snapshotValue["event name"] as! String
        self.dateOf = snapshotValue["event date"] as! String
        self.price = snapshotValue["price"] as! String
        self.completed = snapshotValue["completed"] as! Bool
    }
}
