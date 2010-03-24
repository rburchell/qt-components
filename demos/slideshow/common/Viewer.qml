import Qt 4.6
import PhotoModel 1.0

//Picture View
Item {
    id: root;
    anchors.fill: parent;

    property alias interval: timer.interval;
    property bool running;
    property alias animItem: loader.item;
    property string path;
    property int index: 0;

    // Triggers the animator transitions
    // default interval: 1000 milliseconds
    Timer {
        id: timer;
        running: root.running && !animItem.running;
        repeat: false;
        onTriggered: {
            animItem.start();
        }
    }

    // view animator loader
    Loader {
        id: loader;
        anchors.fill: parent;

        onStatusChanged: {
            switch (loader.status) {
                case Loader.Ready: {
                    animItem.anchors.fill = loader;
                    init();
                    break;
                }
                case Loader.Null:
                case Loader.Error: {
                    console.log('Error: Cannot load view animator');
                    loader.source =  "";
                    timer.running = false;
                    break;
                }
            }
        }
    }

    Script {
        function musicas() {
            photoModel.path = root.path;
            return photoModel.list;
        }

        function init()
        {
            var list = musicas();
            animItem.currentImage = list[0];
            animItem.nextImage = list[1];
            index = 1;
            animItem.finished.connect(getNext);
        }

        function getNext()
        {
            var list = musicas();
            index = (index + 1) % photoModel.size;
            animItem.nextImage = list[index];
        }
    }

    states: [
    State {
        name: "fade";
        PropertyChanges {target: loader; source: "FadeAnimator.qml";}
    },
    State {
        name: "sliding";
        PropertyChanges {target: loader; source: "SlidingAnimator.qml";}
    },
    State {
        name: "transform";
        PropertyChanges {target: loader; source: "TransformAnimator.qml";}
    }
    ]
}
