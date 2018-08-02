
var enabled: Bool {
        didSet {                                                            // what does the whole block do?
            if let segmentedControl = self.segmentedControl {
                segmentedControl.isEnabled = enabled
            }
        }
    }

/* looks like if let foo = bar {
                * do something with or to foo *
              }

is necessary doing something to something if it is not nil, that is, i believe, it unwraps
the optional-object Bar (which is an Optional<Bar>, or so).
*/

// -------------------------------------------------------------------------------------------------

class RouteTypeCell: UITableViewCell {

    @IBOutlet var segmentedControl: UISegmentedControl!                 // what is the @IBOutlet? what is the !

    weak var delegate: RouteTypeCellDelegate?                           // what is weak? what is ? ?

    var routeType: AMSDataRouteType {
        didSet {
            if let segmentedControl = self.segmentedControl {
                switch self.routeType {
                case .fastest:
                    segmentedControl.selectedSegmentIndex = 0
                case .shortest:
                    segmentedControl.selectedSegmentIndex = 1
                case .balanced:
                    segmentedControl.selectedSegmentIndex = 2
                }
            }
        }
    }

    var enabled: Bool {
        didSet {
            if let segmentedControl = self.segmentedControl {
                segmentedControl.isEnabled = enabled
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {                           // required: every subclass must implement this initializer  ...anything else in question ?
        self.routeType = .fastest
        self.enabled = true
        super.init(coder: aDecoder)
    }

    // MARK: Actions                                                    // ?

    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {

        var routeType: AMSDataRouteType?                                // ?
        switch sender.selectedSegmentIndex {
        case 0:
            routeType = .fastest
        case 1:
            routeType = .shortest
        case 2:
            routeType = .balanced
        default:
            routeType = nil
        }

        if let routeType = routeType {
            self.delegate?.routeTypeCell(self, didChangeRouteType: routeType)           // ?
        }
    }
}

// -------------------------------------------------------------------------------------------------

func routeTypeCell(_ indexPath: IndexPath) -> UITableViewCell {

                                                                                        // guard? as?
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "routeTypeCell") as? RouteTypeCell else {
            return UITableViewCell()
        }

        cell.routeType = self.routeType
        cell.delegate = self

        return cell
    }

// -------------------------------------------------------------------------------------------------

if let route = segment.route, let mapRoute = NMAMapRoute(route),
    let boundingBox = route.boundingBox {
    self.mapView.add(mapObject: mapRoute)
    self.mapView.set(boundingBox: boundingBox,
                     animation: NMAMapAnimation.bow)
}

// -------------------------------------------------------------------------------------------------

for index in 1...limitRoutes {
            let route
                = AMSDataRoute(segments: [createRandomSegment(index), createRandomSegment(index)])
            route.name = "QA:Route[\(index)]\(route.routeHash() ?? "unknown")"                        // ??
            route.addTag(AMSDataTagBuilder.sharedTag())
            routes.append(route)
        }

// -------------------------------------------------------------------------------------------------


let request = URLRequest(url: url)                                      // what's the difference to var ?

open func remove(_ clusterLayer: NMAClusterLayer!) -> Bool          // open?   _ ?    ! ?/


//--------------------------------------------------------------------------------------------------

self?                       // what does this mean ?
weak self                   // same game

//--------------------------------------------------------------------------------------------------

let stylesURL = Bundle(for: type(of: self)).bundleURL.appendingPathComponent("MapStyles")       // ??

//--------------------------------------------------------------------------------------------------

func configureCustomMapStyles(from srcFolderURL: URL, key mapStylesKey: String) -> Bool      // from, key ??


//--------------------------------------------------------------------------------------------------

let contents = try fileManager.subpathsOfDirectory(atPath: src.path)                  // try without catch ??


//--------------------------------------------------------------------------------------------------

let _ = fileManager.fileExists(atPath: itemSrcURL.path, isDirectory: &srcIsDirectory)     // let _ ??


// -------------------------------------------------------------------------------------------------

open
public
interal
private


open class AMSDataTagBuilder : NSObject {                                   // open ? is there open in another context?


// -------------------------------------------------------------------------------------------------

instance0.trafficSpeed = [ 1 : 1, 2 : 2 ]

// -------------------------------------------------------------------------------------------------

internal class _Attributes: Attributes {

    var builtInTypeAttribute: UInt32 {                                          // custom implementation for get / set ?
        get {
            return smoke_Attributes_builtInTypeAttribute_get(c_instance)
        }
        set {
            return smoke_Attributes_builtInTypeAttribute_set(c_instance, newValue)      // set and return ???
        }
    }

// -------------------------------------------------------------------------------------------------

deinit {                                            // is it like a d'tor?
        smoke_Attributes_release(c_instance)
    }

// -------------------------------------------------------------------------------------------------

public class MyWrapper<T> : Collection {
    public subscript(position: Int) -> T { get }  // like a Cpp operator overload MyWrapper<String>[42]
}

// -------------------------------------------------------------------------------------------------

public static func explicitArrayMethod<T>(input: T) -> T where T : Collection, T.Element == Arrays.SyncResult {  // == ??
        return examples_Arrays_explicitArrayMethod(input)
    }

// -------------------------------------------------------------------------------------------------

class DeinitListener : EmptyListener {
    let deinitCallback: () -> Void
    init(callOnDeinit: @escaping () -> Void) {        // escaping
        self.deinitCallback = callOnDeinit
    }

    deinit {
        deinitCallback()
    }
}

// -------------------------------------------------------------------------------------------------

@IBInspectable
@IBAction

// -------------------------------------------------------------------------------------------------

var isMapLoaded: Bool = false {
    willSet {                                       // probably related to didSet.. but.. what ??
     self.noMapDataView?.isHidden = newValue
    }
}




@objc  // indicates functions that use objective c framework