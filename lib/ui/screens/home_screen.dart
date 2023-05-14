import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/ui/player/player_controller.dart';
import 'package:harmonymusic/ui/utils/theme_controller.dart';
import 'package:harmonymusic/ui/widgets/content_list_widget_item.dart';
import 'package:harmonymusic/ui/widgets/create_playlist_dialog.dart';

import '../navigator.dart';
import '../utils/home_library_controller.dart';
import '../widgets/content_list_widget.dart';
import '../widgets/list_widget.dart';
import '../widgets/quickpickswidget.dart';
import '../widgets/shimmer_widgets/home_shimmer.dart';
import 'home_screen_controller.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PlayerController playerController = Get.find<PlayerController>();
  final HomeScreenController homeScreenController =
      Get.find<HomeScreenController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
          visible: true,
          child: Obx(
            () => Padding(
              padding: EdgeInsets.only(
                  bottom: playerController.playerPanelMinHeight.value == 0
                      ? 20
                      : 75),
              child: SizedBox(
                height: 60,
                width: 60,
                child: FittedBox(
                  child: FloatingActionButton(
                      focusElevation: 0,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14))),
                      elevation: 0,
                      onPressed: () async {
                        Get.toNamed(ScreenNavigationSetup.searchScreen,
                            id: ScreenNavigationSetup.id);
                        // file:///data/user/0/com.example.harmonymusic/cache/libCachedImageData/
                        //file:///data/user/0/com.example.harmonymusic/cache/just_audio_cache/
                        // final cacheDir = (await getTemporaryDirectory()).path;
                        // if (io.Directory("$cacheDir/libCachedImageData/")
                        //     .existsSync()) {
                        //   final file =
                        //       io.Directory("$cacheDir/cachedSongs").listSync();
                        //   // inspect(file);
                        //   final downloadedFiles =
                        //       io.Directory("$cacheDir/cachedSongs")
                        //           .listSync()
                        //           .where((f) => !['mime', 'part'].contains(
                        //               f.path.replaceAll(RegExp(r'^.*\.'), '')));
                        //   // print(downloadedFiles);
                        // }
                        // if (io.Directory("$cacheDir/libCachedImageData/")
                        //     .existsSync()) {
                        //   final audioFiles =
                        //       io.Directory("$cacheDir/libCachedImageData/")
                        //           .listSync();

                        //   //inspect(audioFiles);
                        // }
                      },
                      child: const Icon(Icons.search)),
                ),
              ),
            ),
          )),
      body: Row(
        children: <Widget>[
          // create a navigation rail
          Obx(
            () => NavigationRail(
              useIndicator: false,
              selectedIndex:
                  homeScreenController.tabIndex.value, //_selectedIndex,
              onDestinationSelected: homeScreenController.onTabSelected,
              minWidth: 60,
              leading: const SizedBox(height: 60),
              labelType: NavigationRailLabelType.all,
              //backgroundColor: Colors.green,
              destinations: <NavigationRailDestination>[
                railDestination("Home"),
                railDestination("Songs"),
                railDestination("Playlists"),
                railDestination("Albums"),
                railDestination("Artists"),
                //railDestination("Settings")
                const NavigationRailDestination(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  icon: Icon(Icons.settings),
                  label: SizedBox.shrink(),
                  selectedIcon: Icon(Icons.settings),
                )
              ],
            ),
          ),
          //const VerticalDivider(thickness: 1, width: 2),
          Expanded(
            child: Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                // switchInCurve: Curves.easeIn,
                // switchOutCurve: Curves.easeOut,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(1.2, 0),
                              end: const Offset(0, 0))
                          .animate(animation),
                      child: child);
                },
                layoutBuilder: (currentChild, previousChildren) =>
                    currentChild!,
                child: Center(
                  key: ValueKey<int>(homeScreenController.tabIndex.value),
                  child: bodyItem(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bodyItem() {
    if (homeScreenController.tabIndex.value == 0) {
      return Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 90, top: 90),
          child: Obx(() {
            return Column(
              children: homeScreenController.isContentFetched.value
                  ? (homeScreenController.homeContentList).map((element) {
                      if (element.runtimeType.toString() == "QuickPicks") {
                        //return contentWidget();
                        return QuickPicksWidget(content: element);
                      } else {
                        return ContentListWidget(
                          content: element,
                        );
                      }
                    }).toList()
                  : [const HomeShimmer()],
            );
          }),
        ),
      );
    } else if (homeScreenController.tabIndex.value == 1) {
      return Padding(
        padding: const EdgeInsets.only(left: 5.0, top: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Library Songs",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 10),
            GetX<LibrarySongsController>(builder: (controller) {
              return controller.cachedSongsList.isNotEmpty
                  ? ListWidget(
                      controller.cachedSongsList,
                      "Library Songs",
                      true,
                      isPlaylist: true,
                    )
                  : Expanded(
                      child: Center(
                          child: Text(
                        "No Songs!",
                        style: Theme.of(context).textTheme.titleMedium,
                      )),
                    );
            })
          ],
        ),
      );
    } else if (homeScreenController.tabIndex.value == 2) {
      return const PlaylistNAlbumLibraryWidget(isAlbumContent: false);
    } else if (homeScreenController.tabIndex.value == 3) {
      return const PlaylistNAlbumLibraryWidget();
    } else if (homeScreenController.tabIndex.value == 4) {
      return const LibraryArtistWidget();
    } else if (homeScreenController.tabIndex.value == 5) {
      return const SettingsScreen();
    } else {
      return Center(
        child: Text("${homeScreenController.tabIndex.value}"),
      );
    }
  }

  NavigationRailDestination railDestination(String label) {
    return NavigationRailDestination(
      icon: const SizedBox.shrink(),
      label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: RotatedBox(quarterTurns: -1, child: Text(label))),
    );
  }
}

class LibraryArtistWidget extends StatelessWidget {
  const LibraryArtistWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cntrller = Get.find<LibraryArtistsController>();
    return Padding(
      padding: const EdgeInsets.only(left: 5, top: 90.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Library Artists",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 10),
          Obx(() => cntrller.libraryArtists.isNotEmpty
              ? ListWidget(cntrller.libraryArtists, "Library Artists", true)
              : Expanded(
                  child: Center(
                      child: Text(
                  "No Bookmarks!",
                  style: Theme.of(context).textTheme.titleMedium,
                ))))
        ],
      ),
    );
  }
}

class PlaylistNAlbumLibraryWidget extends StatelessWidget {
  const PlaylistNAlbumLibraryWidget({super.key, this.isAlbumContent = true});
  final bool isAlbumContent;

  @override
  Widget build(BuildContext context) {
    final libralbumCntrller = Get.find<LibraryAlbumsController>();
    final librplstCntrller = Get.find<LibraryPlaylistsController>();
    var size = MediaQuery.of(context).size;

    const double itemHeight = 220;
    const double itemWidth = 180;

    return Padding(
      padding: const EdgeInsets.only(top: 90.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    isAlbumContent ? "Library Albums" : "Library Playlists",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                isAlbumContent
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.only(right: size.width * .05),
                        child: InkWell(
                          onTap: () => showDialog(
                              context: context,
                              builder: (context) =>
                                  const CreateNRenamePlaylistPopup()),
                          child: Icon(
                            Icons.playlist_add_rounded,
                            color:
                                Theme.of(context).textTheme.titleLarge!.color,
                            size: 25,
                          ),
                        ),
                      )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(
              () => (isAlbumContent
                      ? libralbumCntrller.libraryAlbums.isNotEmpty
                      : librplstCntrller.libraryPlaylists.isNotEmpty)
                  ? GridView.builder(
                    physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: (size.width / itemWidth).ceil(),
                        childAspectRatio: (itemWidth / itemHeight),
                      ),
                      controller: ScrollController(keepScrollOffset: false),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.only(bottom: 70,top:10),
                      itemCount: isAlbumContent
                          ? libralbumCntrller.libraryAlbums.length
                          : librplstCntrller.libraryPlaylists.length,
                      itemBuilder: (context, index) => Center(
                            child: ContentListItem(
                              content: isAlbumContent
                                  ? libralbumCntrller.libraryAlbums[index]
                                  : librplstCntrller.libraryPlaylists[index],
                              isLibraryItem: true,
                            ),
                          ))
                  : Center(
                      child: Text(
                      "No Bookmarks!",
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
            ),
          )
        ],
      ),
    );
  }
}
