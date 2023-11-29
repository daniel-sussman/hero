puts "Wiping all categories from the database..."

Category.destroy_all

puts "Creating categories..."

playgrounds = Category.create(name: "playgrounds")
soft_play = Category.create(name: "soft play")
museums = Category.create(name: "museums")
leisure_centres = Category.create(name: "leisure centres")
swimming = Category.create(name: "swimming")
bouncy_castles = Category.create(name: "bouncy castles")
restaurants_and_cafes = Category.create(name: "restaurants and cafes")
arts_and_crafts = Category.create(name: "arts and crafts")
music = Category.create(name: "music")
adventure_playgrounds = Category.create(name: "adventure playgrounds")
indoor = Category.create(name: "indoor")
outdoor = Category.create(name: "outdoor")
theatre = Category.create(name: "theatre")
stay_and_play = Category.create(name: "stay and play")
play_cafe = Category.create(name: "play cafe")
animals = Category.create(name: "animals")
farms = Category.create(name: "farms")

puts "Wiping all activities from the database..."

Activity.destroy_all

puts "Seeding the database with new activities..."

params = {
  title: "Shoreditch Park Playground",
  address: "14 Rushton St, London N1 5DR",
  description: "A very nice recently rebuilt playground. It is of a decent size: there are 12 swings (including one circular mega swing, 4 ones with toddler seats and one with a big chair which, I guess, is suitable for people with reduced mobility), three different slides, a seesaw, a sandpit, a few climbing structures, a xylophone, plus several benches for parents or carers to sit on.",
  photo_url: "https://lh5.googleusercontent.com/p/AF1QipO2eExh9iEck1mHmkCXxReAMTU-SpUC06wJbJpt",
  monday_opening_hours: "all day",
  tuesday_opening_hours: "all day",
  wednesday_opening_hours: "all day",
  thursday_opening_hours: "all day",
  friday_opening_hours: "all day",
  saturday_opening_hours: "all day",
  sunday_opening_hours: "all day"
}
new_activity = Activity.create(params)

ActivityCategory.create(activity_id: new_activity.id, category_id: playgrounds.id)
ActivityCategory.create(activity_id: new_activity.id, category_id: outdoor.id)

params = {
  title: "Tumbling Bay Playground",
  address: "Olympic Park Ave, London E20 1DY",
  description: "Kids' play equipment including slides & swings, treehouses, bridges, rock pools & sand pits.",
  photo_url: "https://lh5.googleusercontent.com/p/AF1QipNw6UOQKk8Wk11y41ZtsC3JEw-IftnhwWrXyU2y",
  monday_opening_hours: "7 am-11 pm",
  tuesday_opening_hours: "7 am-11 pm",
  wednesday_opening_hours: "7 am-11 pm",
  thursday_opening_hours: "7 am-11 pm",
  friday_opening_hours: "7 am-11 pm",
  saturday_opening_hours: "7 am-11 pm",
  sunday_opening_hours: "11 am-5 pm"
}
new_activity = Activity.create(params)

ActivityCategory.create(activity_id: new_activity.id, category_id: playgrounds.id)
ActivityCategory.create(activity_id: new_activity.id, category_id: outdoor.id)

params = {
  title: "Clissold Park Playground",
  address: "Clissold Park, Church Street, London N16 9HJ",
  description: "Very spacious and has the soft flooring. Lots of kids are able to play together or by themselves. There are also benches and seating area to watch the kids. I highly recommend for toddlers to kids to play.",
  photo_url: "https://lh5.googleusercontent.com/p/AF1QipMtPhk5uGhUjK0n0-tidVLcCn7QP27EAZsHZ6gs",
  monday_opening_hours: "7:30 am-5:30 pm",
  tuesday_opening_hours: "7:30 am-5:30 pm",
  wednesday_opening_hours: "7:30 am-5:30 pm",
  thursday_opening_hours: "7:30 am-5:30 pm",
  friday_opening_hours: "7:30 am-5:30 pm",
  saturday_opening_hours: "7:30 am-5:30 pm",
  sunday_opening_hours: "7:30 am-5:30 pm"
}
new_activity = Activity.create(params)

ActivityCategory.create(activity_id: new_activity.id, category_id: playgrounds.id)
ActivityCategory.create(activity_id: new_activity.id, category_id: outdoor.id)

params = {
  title: "Kidzmania",
  address: "28 Powell Rd, Lower Clapton, London E5 8DJ",
  description: "The food is tasty and well priced. Staff is efficient and helpful. Toilets are clean. What's not to like? We're lucky to have Kidzmania around the corner.",
  photo_url: "https://lh5.googleusercontent.com/p/AF1QipMEhSRJdPiDFTvNGkvhHOPRFKY6pc-JxbXWngPf",
  website_url: "http://www.kidzmania.co.uk/",
  monday_opening_hours: "10 am-3 pm",
  tuesday_opening_hours: "10 am-3 pm",
  wednesday_opening_hours: "10 am-3 pm",
  thursday_opening_hours: "11:30 am-3 pm",
  friday_opening_hours: "10 am-4 pm",
  saturday_opening_hours: "10 am-5 pm",
  sunday_opening_hours: "10 am-5 pm"
}
new_activity = Activity.create(params)

ActivityCategory.create(activity_id: new_activity.id, category_id: soft_play.id)
ActivityCategory.create(activity_id: new_activity.id, category_id: indoor.id)

params = {
  title: "Sobell Leisure Centre",
  address: "Tollington Rd, London N7 7NY",
  description: "Huge complex offering indoor & outdoor sports courts, a boxing gym & a fitness centre.",
  photo_url: "https://lh5.googleusercontent.com/p/AF1QipOGx1tQu97nrLRd0lgn230_WtWQwWct5xaCpC_o",
  website_url: "https://www.better.org.uk/leisure-centre/london/islington/sobell",
  monday_opening_hours: "6:30 am-10pm",
  tuesday_opening_hours: "6:30 am-10pm",
  wednesday_opening_hours: "6:30 am-10pm",
  thursday_opening_hours: "6:30 am-10pm",
  friday_opening_hours: "6:30 am-10pm",
  saturday_opening_hours: "8 am-6 pm",
  sunday_opening_hours: "8 am-6 pm"
}
new_activity = Activity.create(params)

ActivityCategory.create(activity_id: new_activity.id, category_id: soft_play.id)
ActivityCategory.create(activity_id: new_activity.id, category_id: indoor.id)
ActivityCategory.create(activity_id: new_activity.id, category_id: leisure_centres.id)
ActivityCategory.create(activity_id: new_activity.id, category_id: swimming.id)

params = {
  title: "Queensbridge Sports and Community Centre",
  address: "30 Holly St, London E8 3XW",
  description: "Great soft play on Wednesdays. Plenty of things for the kids, and friendly staff. You can book online as well. They have wheelchair and buggy accessible toilets. And space to park your buggy.",
  photo_url: "https://lh5.googleusercontent.com/p/AF1QipMme2KGPS3ahxbI3xg-wRLIv41Itaqx8cxxwVdf",
  website_url: "https://www.better.org.uk/leisure-centre/london/hackney/queensbridge-sport-and-community-centre",
  monday_opening_hours: "7 am-10 pm",
  tuesday_opening_hours: "7 am-10 pm",
  wednesday_opening_hours: "7 am-10 pm",
  thursday_opening_hours: "7 am-10 pm",
  friday_opening_hours: "7 am-10 pm",
  saturday_opening_hours: "9 am-5 pm",
  sunday_opening_hours: "9 am-5 pm"
}
new_activity = Activity.create(params)

ActivityCategory.create(activity_id: new_activity.id, category_id: soft_play.id)
ActivityCategory.create(activity_id: new_activity.id, category_id: indoor.id)
ActivityCategory.create(activity_id: new_activity.id, category_id: leisure_centres.id)
ActivityCategory.create(activity_id: new_activity.id, category_id: bouncy_castles.id)

params = {
  title: "Young V&A",
  address: "Cambridge Heath Rd, Bethnal Green, London E2 9PA",
  description: "Toys, clothes and interactives in 1872 hangar with marble floor and visible cast iron skeleton.",
  photo_url: "https://lh3.googleusercontent.com/gps-proxy/AFm_dcR9oH-OV09K0_efNhKYtkCBcCOpEwQowfZYd4HOJcwWKt4ve3YufrU-CSgzxealj6RouzK9pA2YavE_1pRbFc_y4YHgYmidyD-edVnIZUEfYCdh3fic9SnCWBEVtq7QRvwQdykqeJOvF2zUgCJ1UPc_hZaxQxMJoYaEg6c8SFXyYUvRc5-35wM",
  website_url: "https://www.vam.ac.uk/young/",
  monday_opening_hours: "10 am-5:45 pm",
  tuesday_opening_hours: "10 am-5:45 pm",
  wednesday_opening_hours: "10 am-5:45 pm",
  thursday_opening_hours: "10 am-5:45 pm",
  friday_opening_hours: "10 am-5:45 pm",
  saturday_opening_hours: "10 am-5:45 pm",
  sunday_opening_hours: "10 am-5:45 pm"
}
new_activity = Activity.create(params)

ActivityCategory.create(activity_id: new_activity.id, category_id: museums.id)
ActivityCategory.create(activity_id: new_activity.id, category_id: indoor.id)
ActivityCategory.create(activity_id: new_activity.id, category_id: arts_and_crafts.id)
