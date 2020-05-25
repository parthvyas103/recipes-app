import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/categories.dart';
import 'package:flutter_complete_guide/screens/categories_screen.dart';
import 'package:flutter_complete_guide/screens/filters_screen.dart';
import 'package:flutter_complete_guide/screens/recipe_item_screen.dart';
import 'package:flutter_complete_guide/screens/recipe_screen.dart';
import 'package:flutter_complete_guide/screens/tabs_screen.dart';
import 'models/meal.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false
  };
  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favoriteMeals = DUMMY_MEALS;
  void _setFilters(Map<String, bool> newFilters) {
    setState(() {
      _filters = newFilters;
      _availableMeals = DUMMY_MEALS.where((test) {
        if (_filters['gluten'] && !test.isGlutenFree) {
          return false;
        }
        if (_filters['lactose'] && !test.isLactoseFree) {
          return false;
        }
        if (_filters['vegan'] && !test.isVegan) {
          return false;
        }
        if (_filters['vegetarian'] && !test.isVegetarian) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavourites(String mealId) {
    final existingIndex =
        _favoriteMeals.indexWhere((meal) => mealId == meal.id);
    if (existingIndex >= 0) {
      setState(() {
        _favoriteMeals.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favoriteMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
      });
    }
  }

  bool _isFavourite(String id) {
    return _favoriteMeals.any((meal) => meal.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 20,
                fontWeight: FontWeight.bold),
            body1: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            body2: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            )),
      ),
      home: TabsScreen(_favoriteMeals),
      routes: {
        RecipeScreen.routeName: (ctx) => RecipeScreen(_availableMeals),
        RecipeItemScreen.routeName: (ctx) =>
            RecipeItemScreen(_toggleFavourites, _isFavourite),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_setFilters, _filters),
      },
      onGenerateRoute: (settings) {
        print(settings.arguments);
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => CategoriesScreen());
      },
    );
  }
}
