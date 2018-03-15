import Routing
import Vapor
import Leaf

/*
Leaf Template Basics
 Need to Return a Future<View> to display HTML
 Any data you pass to a template is called its "Context"
 The #embed("leaf file without the extension") allows you to insert templates into other templates. Ex Footer template embeded at bottom of every view
 
*/
public func routes(_ router: Router) throws {
    /* Home/Defualt Route.  The Future<View> is a Leaf View that will be rendered at some point.
    
     */
    router.get  { req -> Future<View> in
        //
        let context = [String: String]()
        return try req.view().render("home", context)
    }
    
    router.get("contact"){ req -> Future<View> in
        let context = [String: String]()
        return try req.view().render("contact", context)
    }
    
    router.get("staff"){ req -> Future<View> in
        let context = [String: String]()
        return try req.view().render("staff", context)
    }
    
    // The route is /staff/STRING
    router.get("staff", String.parameter){ req -> Future<View> in
        let name = try req.parameter(String.self)
        
        // Creates some dummy data
        let bios = ["kirk": "My name is James Kirk and I love snakes.",
                    "picard": "My name is Jean-Luc Picard and I'm mad for fish.",
                    "sisko": "My name is Benjamin Sisko and I'm all about the budgies.",
                    "janeway": "My name is Kathryn Janeway and I want to hug every hamster.",
                    "archer" : "My name is Jonathan Archer and beagles are my thing."
                    ]
        struct StaffView : Codable {
            var name: String?
            var bio: String?
            var allNames: [String]
        }
        
        let context: StaffView
        
        if let bio = bios[name]{
            context = StaffView(name: name, bio: bio, allNames: bios.keys.sorted())
        } else{
            context = StaffView(name:nil, bio:nil, allNames: bios.keys.sorted())
        }
        return try req.view().render("staff", context)
    }
}
