# Packages
package1 = Package.find_or_initialize_by(price_cents: 20 * 100)
package1.name = "I'm just hungry"
package1.selling_points = [
  'maximaal 2 gangen', 'een sfeervolle ambiance', 'geen michelin sterren'
]
package1.image = File.open('app/assets/images/themes/im-just-hungry.jpg')
package1.featured = true
package1.save

package2 = Package.find_or_initialize_by(price_cents: 30 * 100)
package2.name = 'Not your average'
package2.selling_points = [
  'minimaal 2,5 gangen', 'veel variatie', 'goede keukens'
]
package2.image = File.open('app/assets/images/themes/not-your-average.jpg')
package2.featured = true
package2.save

package3 = Package.find_or_initialize_by(price_cents: 40 * 100)
package3.name = 'Fine dining'
package3.selling_points = [
  'minimaal 3 gangen', 'verassend mooie gerechten', 'speciaal voor food-lovers'
]
package3.image = File.open('app/assets/images/themes/fine-dining.jpg')
package3.featured = true
package3.save


# Restaurants
restaurant = FactoryGirl.create(:restaurant)
restaurant.packages << package1
restaurant.packages << package2
restaurant.packages << package3

# Reviews
review1 = Review.new
review1.quote = 'Wat een geweldig concept! Ik bepaal nooit zelf meer waar ik uit eten wil gaan.'
review1.name = 'Henk de Vries'
review1.featured = true
review1.image = File.open('app/assets/images/themes/im-just-hungry.jpg')
review1.save

review2 = Review.new
review2.quote = 'Goed eten EN een leuke avond, wat wil je nog meer?'
review2.name = 'Kees de Groot'
review2.featured = true
review2.image = File.open('app/assets/images/themes/not-your-average.jpg')
review2.save

review3 = Review.new
review3.quote = 'Ik ben verliefd op Surprise Dinner.'
review3.name = 'Greet van der Steur'
review3.featured = true
review3.image = File.open('app/assets/images/themes/fine-dining.jpg')
review3.save