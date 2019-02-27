# stanwood-assignment

## This is iOS assignment done for stanwood.io


### General architecture of the application
Basically it is MVVM + Services + Router. Although using StanwoodCore breaks some principles, i.e. ViewModel is kind of tiny because of Elements and stuff that is going on with dataSource / delegate for collection view.
Router has both coordinator’s and router’s responsibility to keep it simpler for such a small app.
Service layer is implemented using ServiceLocator pattern. I think it’s most practical and easy to implement.
ModuleFactory is responsible for creation of all view things with its dependencies. In big projects this would be definitely divided into sub-factories that create separate modules to comply to single responsibility principle and not to couple stuff too tight.


### Technical choices
- First of all, I’ve done a lot of macOS development and less iOS. I don’t consider myself an expert in UIKit, hence I had to take this into account and plan ahead that something can be unclear/unknown to me, so I wanted to keep everything as simple as I can to avoid being stuck at something.
- Normally I only use code (without storyboard and xibs), as I’d do on any project which I want to easily maintain in future. From my experience working on multiple Apple ecosystem projects, Storyboard/XIBs introduce a lot of overhead (merge conflicts; constant need to look up property settings in both XIBs and code; no compile-time checking for anything hence not very safe). My favourite is to have ViewController + View as separate files/classes in the code, but that also introduces another layer of complexity, so for simple views it’s enough to have single ViewController (although obviously breaks some of clean architecture principle - but I’d break anything that in result keeps things simpler in real life).
- I had to use XIB for UICollectionViewCell, as StanwoodCore would produce crash if I wouldn’t. So it’s not very flexible.
- Initially I thought to use SplitViewController as it plays well with iPhone / iPad without doing any layout manually. However SplitViewController is a great choice when detail view controller represents main functionality. In this app GitHub repositories list is main functionality and detail view is kind of helper view. So when detail view is open by default on iPad, that doesn’t work well. As result I replaced SplitViewController with NavigationController. If I had more time and it was for a production use, I’d definitely implemented some custom view where on the left you have a repositories list and on the right you’d have detail view (on iPads and on horizontal orientation for iPhones).


### Not implemented features
- Infinite scrolling. Not sure how exactly I would implement it, but I think it would be something  like prefetching 2 full pages of repositories and displaying only 1. If a user goes onto second page, then I’d prefetch 3rd page etc. I’d also had to think about update strategy, i.e. how much time should pass until prefetched data can be considered outdated (and hence have to be prefetched again). Same goes with existing list of records, probably once in a while we’d like to update the list (or at least when app goes into foreground, for instance).
- Cell selection and showing detail view. I’d probably catch cell selection and use notification dispatch with git hub repo info in userinfo (with custom pack/unpack method to keep things strict) and listen to it in Router (as handling should happen in a place where UI hierarchy is known). If I’d use delegate pattern, we’d ended up with delegates chain, which introduces complexity, reduces readability and maintainability (if you need to change something, you have to change whole chain). Notifications, on the other hand, are easy to read and if applied properly, it’s a good tool to use.
- UI for favorites list. That’s quite simple, just use Favorites service to get the data, load into the list. If user removes something from the list, then update via Favorites service. I prefer duplication over wrong abstraction, so although Favorites represent the same data format that repositories list has, I’d definitely not re-use existing collection view via encapsulating it in another view controller. I’d just duplicate code for repositories view controller and cell and removed what’s not needed.
- Unit testing for services, view models and other stuff which might contain important code
- We could add mock services (sometimes API breaks or is just unavailable, the development should continue regardless)
- Separate factories for creation/configuration of separate modules (like repositories, favorites etc.)
- GitHub API could be a separate module and used as a facade, where each of GitHub API subroutes/endpoints could be implemented as a separate object
- Use something like Reachability framework to handle internet online/offline. If initially offline when app is launched, instead of repositories list I’d display something like “Seems like you are offline. Please check your internet connection and try again.”. If transition from online to offline happens while using the app and user is trying to load more repositories, I’d display an alert with message like in previous example and “OK” button as a simple solution. If transition from offline to online happens, I’d just reload current list maintaining a scroll position of a user.
- For the search in each list, I’d implement online search for repositories. For instance, if a user typed something into search, I’d immediately filter local data and also fired a request to GitHub Search API and see if anything is found there (pretty sure it will find something), and present the results in the list below local results (also would remove duplicated records). For favorites it would just be a local search through existing records in the favorites data storage.
- NetworkRequestor that could be reused in multiple network services.
- I’d also see what’s going on with the cell width when you rotate the device, it seems to be stuck at same width.
- I’d also scale width of SegmentedControl in the navigation bar based on width when rotated and set segment width based on text width & some min width, depending on what is bigger.


### StanwoodCore
I studied the source code of `StanwoodCore` a little bit and can say the following:
- I will definitely lack higher-level constraints composing code (you partially have it in UIView extension, i.e. `addConstraints`, but I’d also need a lot more like centering, applying fixed width and height, applying different edges constraints with/without insets etc.). Obviously if you normally use something like SnapKit or other constraints libraries - that’s fine not to have it).
- I would also need a solution to add child controllers to container/parent controllers
- I don’t really like how TimeInterval extension is made. I always want to read clear code and if I read something like `asyncAfter(.tiny)`, I’d definitely need to go into the library to see what the “.tiny” is. And as you have a lot of these, I’m pretty sure you are visiting it as well (unless you applied it for years and remembered all those). I’d suggest having something where you explicitly have a number and a time specifier like `0.5.seconds` or `1.minute`. That would be clear to anyone, even those who don’t know the library.
- For `Storage`, there definitely a need to add to/remove from a file opposite to only creating/replacing/removing a file every time. But of course I don’t know use cases you had in mind when creating this :)
- I couldn’t understand `Presentable` source quickly enough, so I just skipped it.
- Also, do you do all structs/classes inside `Stanwood` global struct to replicate `namespace` functionality? So that it doesn’t conflict with anything? Not very clear intention.
- Overall, I feel like the library needs more attention and more use-cases where you can apply it. It also needs a better documentation, if I’d be outside iOS assignment I would never used a library where I have to figure out the code myself before starting to use it (it just takes approx. the same time to understand others complex code than writing it from scratch, in my opinion, at least with the tech that you know).
- I like how you solved enforcing delegate setting with `ForceDelegateble`. Although if using ViewControllers without Storyboard/XIB, one can also enforce it in the constructor params.


### Misc
I’ve spend a lot of time  when working on these things: initial architecture, icons, collection view cell, StanwoodCore study. 
A problem with small assignments which require coming up with clean solution is that you have to spend almost the same amount of time you’d spend on a big project to design initial architecture, and that takes time. 
As the design wasn’t provided in Zeplin or as image assets, I’ve spent quite a while searching for somewhat good looking icons that can also be used without attribution. Eventually I’ve found uxwing.com and had to download PNG icons and resize them accordingly.
Using CollectionViewCell derived from Stanwood.AutoSizeableCell (like in StanwoodCore example project), however it introduced unsatisfiable constraints error. I’ve spent huge amount of time trying to figure out what’s going on with that. The problem was that XIB file had its frame and Stanwood.AutoSizeableCell would try to make another frame (by applying different width). Nothing would help including setting translatesAutoresizingMaskIntoConstraints in both init methods of the cell, or in awakeFromNib (independently on whether you call it before or after super.awakeFromNib). So eventually I had to remove Stanwood.AutoSizeableCell and implement preferredLayoutAttributesFitting in cell, then it started to work correctly and have correct width, flexible height and no constraints error.


I consider the following 4 items as the most frequent issues I face in software engineering:
* Not naming things properly
* Not using access modifiers (and final modifier)
* Writing code that is hard to understand
* Adding comments where they are not needed and NOT adding comments where they are needed
So in my work, I’m always trying to name things properly, most times renaming things until I like the name. I also used to write abstract names in the past until I learned that wrong abstraction is much worse than duplication (I know DRY is great, but clearness and readability is more important imho), so now I’m trying to name things as more concrete as possible (i.e. `AvatarCache` instead of `ImageCache`, for instance - until you realize that you really want to use the class with all kind of images, then you can refactor). 
I always use minimally needed access modifier (e.g. private) whenever a method or a property is only internal logic of an object. The code structured with this in mind is much-much easier to read, when you don’t need to check whether a method is called outside a class, for instance (for any purpose, whether you are refactoring something or just reading and trying to understand the code).
I always mark class as `final` (in rare cases methods as well) if it’s clear it should not be inherited. This also helps resolve compiler source tree quicker, hence reduces time you need to wait for the build to finish. I’m also not a big fan of inheritance. In majority of cases I consider composition as a better way to solve problems.
I’m trying to stick to the simplest readable code that I can imagine when programming (as you read code much more times than you write it, it is very important for other people and for your future self). 
And in regards to comments, I just constantly bump into comments that are obvious (like declaring parameters above the function); but on the other side really complex pieces of code (or tricks/hacks) gets forgotten by programmers and not being commented on. Which leads to ignoring comments when you read the code, as they are also normally outdated. So when I write code, I never add comments unless a piece of code is truly hard to understand, then I’m trying to explain what it means.


P.S. I couldn’t import curl requests that you supplied to Postman as url was malformed. So I had to go to the GitHub API documentation and build it from scratch by myself.
Btw, probably GitHub Search API was updated since iOS assignment creation, as the format of searching for repositories based on created date changed. See https://help.github.com/en/articles/searching-for-repositories#search-by-when-a-repository-was-created-or-last-updated 


P.P.S. I started preferring Carthage over CocoaPods for multiple reasons for 3rd party libraries that you don’t own. It’s just so much simpler approach and performance-wise, when you clean build something it takes ages for a big project to recompile with CocoaPods, while with Carthage (i.e. binary frameworks) you just recompile your codebase without touching libraries. It doesn’t work well with your own libraries that you develop on the fly while developing the application, though.
