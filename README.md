# MonkeyMon
A example flutter project to dive depper into the recent changes in Flutter and popular frameworks. Just a useless idea which purpose is to play around with all fun aspects of Flutter. **It's my personal playground.** 

The project builds around the [Pokeapi](https://pokeapi.co/) and my own [Spring Boot REST API](https://github.com/NachtaktiverHalbaffe/MonkeyAPI-SpringBoot).

The current web version of the flutter app can be accessed via [Github Pages](https://nachtaktiverhalbaffe.github.io/MonkeyMon/) of this repo.

# Project Idea
It's a project to dive into Flutter and experiment with it, so the Application itself is useless and is tailored to cover as most topics as possible. As this is my second full-blown Flutter app, the frameworks etc. are explicitly chosen differemtly from my [first project](https://github.com/NachtaktiverHalbaffe/eje).

At it's core, the application fetches data from [Pokeapi](https://pokeapi.co/) and my own [Spring Boot REST API](https://github.com/NachtaktiverHalbaffe/MonkeyAPI-SpringBoot), caches the data in a powerful local database and shows the entries in a Pokedex and a Mondex (a Pokedex for my Monkey API). Either a Pokemon or a monkey can be send into the arena where they can fight each other like in Pokemon.

My own [Spring Boot REST API](https://github.com/NachtaktiverHalbaffe/MonkeyAPI-SpringBoot) runs on a local Docker Container over localhost, so the Monkey-Part doesnt show anything on the release version of the App.

# Core Tech Stack
Flutter with following (bigger) frameworks and libraries:
- Drift as a persistent database
- Dio for REST-API calls
- For Pokemon remote datasource: A already finished wrapper for [Pokeapi](https://pokeapi.co/)
- Freezed for dataclass generation 
- Riverpod for state management, caching, dependency injection and everything else it replaces
- Mocktail for mocking (testing)
- Widgets:
    - card_swiper for a Tinder-like Listview
    - auto_size_text for automatically adjusting text size
    - animated_notch_bottom_bar as a bottom nav bar
    - cached_network_image for caching network images

# License
Pokémon and Pokémon character names are trademarks of Nintendo.

Copyright 2024 NachtaktiverHalbaffe

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.