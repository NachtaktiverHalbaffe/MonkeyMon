'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"sqlite3.wasm": "f08450f1d5a088a01cec0eb541c3aeca",
"icons/Icon-maskable-192.png": "325617b34e41fc04907482a069310cbd",
"icons/Icon-512.png": "d48be6f9615f0bf72b9728798df82543",
"icons/Icon-192.png": "325617b34e41fc04907482a069310cbd",
"icons/Icon-maskable-512.png": "d48be6f9615f0bf72b9728798df82543",
"version.json": "023f56ef3fc158fe0fe05ad5dd132a9a",
"drift_worker.js": "d0ffbb288564c96c0f86a79e33f0cef5",
"manifest.json": "2a0605020e38b58f0e7ce1d5215728b0",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"index.html": "46108d39420e893fcd2fe030e8cc660a",
"/": "46108d39420e893fcd2fe030e8cc660a",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"favicon.png": "3cdef7d8fdfcaccb1ebe709b07e3c770",
"splash/img/dark-2x.png": "414b24a84729c2b948a5dd57cdd4b9f0",
"splash/img/light-4x.png": "d236b1aec2dc5bda8a4fce9a4c0bbe88",
"splash/img/dark-3x.png": "8f82f087105905b3884713f81a3fbbb8",
"splash/img/light-1x.png": "88e10feb650d51f43989f8c1dad32acd",
"splash/img/light-background.png": "da97f6c824f9b1a2fdb60afd23e2cb08",
"splash/img/dark-1x.png": "88e10feb650d51f43989f8c1dad32acd",
"splash/img/light-2x.png": "414b24a84729c2b948a5dd57cdd4b9f0",
"splash/img/dark-4x.png": "d236b1aec2dc5bda8a4fce9a4c0bbe88",
"splash/img/light-3x.png": "8f82f087105905b3884713f81a3fbbb8",
"main.dart.js": "ec0d958ed372e6784b886f484c7e7542",
"assets/packages/flutter_material_design_icons/assets/materialdesignicons-webfont.ttf": "e051a7a46f37198b988a13071d8160dc",
"assets/AssetManifest.bin": "d5a3906517954296bb589f0b810cbd59",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "04e844c92c41965e75024847cd5bcfc0",
"assets/FontManifest.json": "8d4cc169336920427569b9980d2ad676",
"assets/fonts/MaterialIcons-Regular.otf": "0e6b016990cf441cfe619c31ae763c16",
"assets/AssetManifest.bin.json": "bb4b1b9143242d06850b5d62434a0f10",
"assets/NOTICES": "6fc4ce7ea6910b9143c8576f724ccdac",
"assets/assets/images/3.0x/dark.png": "fc1b17645b37505bd564a03492afcc34",
"assets/assets/images/3.0x/dragon.png": "372bb1f90e09c2a05a5889bb0cb29585",
"assets/assets/images/3.0x/bug.png": "9550d8b8b4045696fab0a65061687c42",
"assets/assets/images/3.0x/fighting.png": "abdaa0ae10aac94130e1d9ab7d210f5a",
"assets/assets/images/3.0x/fairy.png": "f5ee9840c0fa511d21d5883712b318f4",
"assets/assets/images/3.0x/water.png": "8d6ecf244d2d19042d9a932161628522",
"assets/assets/images/3.0x/grass.png": "26a0e593d12cebd75c3a7392f3dc0f2e",
"assets/assets/images/3.0x/rock.png": "f4906fb734d4cf61ab5456c6e92dd2b0",
"assets/assets/images/3.0x/electric.png": "5e232dd41e945ba8aa2e190c20464d1a",
"assets/assets/images/3.0x/ground.png": "afd18dfe5feebdda5e354e6280248a8f",
"assets/assets/images/3.0x/fire.png": "d90c9ef95bb4bf5002ff71f5090b53f5",
"assets/assets/images/3.0x/psychic.png": "29e940578882205c570a39430d5a7763",
"assets/assets/images/3.0x/steel.png": "7fb422ed97b13160ede452df958bac4d",
"assets/assets/images/3.0x/ice.png": "748066ee4302c54f8ecba165a5427fdc",
"assets/assets/images/3.0x/normal.png": "18bcf2614508041ff3754910120c6a27",
"assets/assets/images/3.0x/flutter_logo.png": "b8ead818b15b6518ac627b53376b42f2",
"assets/assets/images/3.0x/poison.png": "0bdb6ed9226d2039a6a2b895e0e2ea30",
"assets/assets/images/3.0x/flying.png": "728bf4d73c610d71aca317a8724c6e10",
"assets/assets/images/3.0x/ghost.png": "ae0fd5372f02d07f893fac62e2c481f0",
"assets/assets/images/dark.png": "7dee75df32bf53994615104c2707b3e1",
"assets/assets/images/dragon.png": "8af66256f6a214dfcff603cc31502eed",
"assets/assets/images/bug.png": "a95f7494d48e705db927ae5831057e3a",
"assets/assets/images/fighting.png": "9f8d9c53de14c50885fa29e79e017f0e",
"assets/assets/images/fairy.png": "51ed6f1efa1cbb256f77d09ff37409ab",
"assets/assets/images/pokemon_background.jpg": "4759997ea2efdd4aa76529cd8c536727",
"assets/assets/images/water.png": "318f0c08984f0a87318b6f0e6cd1c75c",
"assets/assets/images/arena_background.gif": "5122eb5cd46f3ff3630053f4232b8cca",
"assets/assets/images/battle_tile.png": "3937f6a54755b6658e1136d4c340984d",
"assets/assets/images/grass.png": "8208e8ac513afcf45bd3db9a82b045de",
"assets/assets/images/rock.png": "c4031debc2899ce22f03336683b93405",
"assets/assets/images/electric.png": "61ec34391461283692705fe510e7ed5f",
"assets/assets/images/ground.png": "24d5e373341b810f1afea1ab1fd72e6b",
"assets/assets/images/fire.png": "2addb74518dcc078f94ed489aae393e7",
"assets/assets/images/psychic.png": "a953558f56a6f1aecf416f6d4b43f0de",
"assets/assets/images/steel.png": "53ba73c6b5efef5e8c6863f55677fe8c",
"assets/assets/images/arena_background.jpg": "b55af314cb176bc0bdb862da521fc48d",
"assets/assets/images/ice.png": "309a7c1e87ffdc2c8b71ec45329acb42",
"assets/assets/images/normal.png": "3e77d529f153cd4e998263ac95f65874",
"assets/assets/images/flutter_logo.png": "478970b138ad955405d4efda115125bf",
"assets/assets/images/poison.png": "99e77f5a4a8f14b7f22e557b3c3ff8cb",
"assets/assets/images/flying.png": "bfc33c8fe78cb0172f728ced2f879844",
"assets/assets/images/arena_background.png": "cac949c19dec9d184de02cf469b03b56",
"assets/assets/images/2.0x/dark.png": "c182cfcab60c7a14709fcc712182780d",
"assets/assets/images/2.0x/dragon.png": "ec56e5d8e36b775cadb4aa5539a5df73",
"assets/assets/images/2.0x/bug.png": "9a9b44f778c22e2c7884ddeec27ac042",
"assets/assets/images/2.0x/fighting.png": "8c0225a693215adf82e51b3c953f8529",
"assets/assets/images/2.0x/fairy.png": "2550a55e91a8020455e3f2dbb8d486ac",
"assets/assets/images/2.0x/water.png": "4867c833abfa82902c99f8dd842c8203",
"assets/assets/images/2.0x/grass.png": "1dd0eec7c9da0b8b4a980c5a6c5a0120",
"assets/assets/images/2.0x/rock.png": "fba8d144747df77991b6ef00edbe12c2",
"assets/assets/images/2.0x/electric.png": "bd167cd892fdac36e6c05d7b45ae4abc",
"assets/assets/images/2.0x/ground.png": "fc2631d244b887e883f546f30eea3bf6",
"assets/assets/images/2.0x/fire.png": "dd8409a8dada46ae9edc6f524a71d221",
"assets/assets/images/2.0x/psychic.png": "4fa6831383e4493fea6f56f734fd40a7",
"assets/assets/images/2.0x/steel.png": "a9105a30ed121b7606b2e6417c2cb75c",
"assets/assets/images/2.0x/ice.png": "dfdd8f7468bb4d49e6b7ab29e54555f0",
"assets/assets/images/2.0x/normal.png": "7ac93e319503b66ebce67d3b9b47ebca",
"assets/assets/images/2.0x/flutter_logo.png": "4efb9624185aff46ca4bf5ab96496736",
"assets/assets/images/2.0x/poison.png": "bf1e0f0ed16b69ee86558488ed8e32f2",
"assets/assets/images/2.0x/flying.png": "e9197c5cdc99bb53016cbc0cb9833202",
"assets/assets/images/2.0x/ghost.png": "1509c9f579b4c0bca4056a95d9b4aeb2",
"assets/assets/images/ghost.png": "62db66165760d8fdb893914e479ec1b3"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
