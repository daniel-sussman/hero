require 'dotenv/load'

# api_key = ENV['GOOGLEMAPS_API_KEY']
api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'

puts "Wiping all users from the database..."

UserCategory.destroy_all
Child.destroy_all
EncounterCollection.destroy_all
Collection.destroy_all
Encounter.destroy_all
User.destroy_all

puts "Creating users"

User.create(name: "Daniel", address: "285 Highbury Quadrant, London N5 2TD", email: "daniel@example.com", password: "password")

puts "Successfully created #{User.all.count} user."

puts "Wiping all categories from the database..."

ActivityCategory.destroy_all
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
play_cafes = Category.create(name: "play cafes")
animals = Category.create(name: "animals")
farms = Category.create(name: "farms")
science = Category.create(name: "science")
dance_and_gymnastics = Category.create(name: "dance and gymnastics")
sports = Category.create(name: "sports")
historic = Category.create(name: "historic")
theme_parks = Category.create(name: "theme parks")
winter_holidays = Category.create(name: "winter holidays")
libraries = Category.create(name: "libraries")
water_play = Category.create(name: "water play")
forest_school = Category.create(name: "forest school")

puts "Wiping all activities from the database..."

Activity.destroy_all

puts "Seeding the database with new activities..."

Dir[Rails.root.join("db/files/*.json")].first(2).each do |f|
  google_data = JSON.parse(File.open(f).read)

  activity_attributes = {
    title: google_data["result"]["name"],
    description: google_data.dig("result", "editorial_summary", "overview") || (google_data["result"]["reviews"][0]["text"] if google_data["result"]["reviews"]),
    # address: google_data["result"]["formatted_address"]
    latitude: google_data["result"]["geometry"]["location"]["lat"],
    longitude: google_data["result"]["geometry"]["location"]["lng"]
  }
  if google_data['result']['opening_hours']
    activity_attributes[:monday_opening_hours] = google_data["result"]["opening_hours"]["weekday_text"][0].split("day: ")[1]
    activity_attributes[:tuesday_opening_hours] = google_data["result"]["opening_hours"]["weekday_text"][1].split("day: ")[1]
    activity_attributes[:wednesday_opening_hours] = google_data["result"]["opening_hours"]["weekday_text"][2].split("day: ")[1]
    activity_attributes[:thursday_opening_hours] = google_data["result"]["opening_hours"]["weekday_text"][3].split("day: ")[1]
    activity_attributes[:friday_opening_hours] = google_data["result"]["opening_hours"]["weekday_text"][4].split("day: ")[1]
    activity_attributes[:saturday_opening_hours] = google_data["result"]["opening_hours"]["weekday_text"][5].split("day: ")[1]
    activity_attributes[:sunday_opening_hours] = google_data["result"]["opening_hours"]["weekday_text"][6].split("day: ")[1]
  else
    activity_attributes[:monday_opening_hours] = "Varies (check website for schedule)"
    activity_attributes[:tuesday_opening_hours] = "Varies (check website for schedule)"
    activity_attributes[:wednesday_opening_hours] = "Varies (check website for schedule)"
    activity_attributes[:thursday_opening_hours] = "Varies (check website for schedule)"
    activity_attributes[:friday_opening_hours] = "Varies (check website for schedule)"
    activity_attributes[:saturday_opening_hours] = "Varies (check website for schedule)"
    activity_attributes[:sunday_opening_hours] = "Varies (check website for schedule)"
  end
  if google_data['address']
    activity_attributes[:address] = google_data['address']
  end
  new_activity = Activity.create!(activity_attributes)

  if google_data['result']['photos']
    photo_reference = google_data['result']['photos'][0]['photo_reference']
    # make api call
    url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=#{photo_reference}&key=#{api_key}"

    #new_activity.photo.attach(photo)
    file = URI.open(url)
    new_activity.photo.attach(io: file, filename: "#{new_activity.title.gsub(" ", "-")}.jpeg", content_type: 'image/jpeg')
    puts "Successfully created a new activity: #{new_activity.title}"
  else
    puts "Was unable to locate a photo for #{new_activity.title}"
  end

  google_data["categories"].each do |cat|
    ActivityCategory.create!(activity_id: new_activity.id, category_id: Category.find_by(name: cat).id)
  end
end

# params = {
#   title: "Shoreditch Park Playground",
#   address: "14 Rushton St, London N1 5DR",
#   description: "A very nice recently rebuilt playground. It is of a decent size: there are 12 swings (including one circular mega swing, 4 ones with toddler seats and one with a big chair which, I guess, is suitable for people with reduced mobility), three different slides, a seesaw, a sandpit, a few climbing structures, a xylophone, plus several benches for parents or carers to sit on.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipO2eExh9iEck1mHmkCXxReAMTU-SpUC06wJbJpt",
#   monday_opening_hours: "all day",
#   tuesday_opening_hours: "all day",
#   wednesday_opening_hours: "all day",
#   thursday_opening_hours: "all day",
#   friday_opening_hours: "all day",
#   saturday_opening_hours: "all day",
#   sunday_opening_hours: "all day"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: playgrounds.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: outdoor.id)

# params = {
#   title: "Tumbling Bay Playground",
#   address: "Olympic Park Ave, London E20 1DY",
#   description: "Kids' play equipment including slides & swings, treehouses, bridges, rock pools & sand pits.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipNw6UOQKk8Wk11y41ZtsC3JEw-IftnhwWrXyU2y",
#   monday_opening_hours: "7 am-11 pm",
#   tuesday_opening_hours: "7 am-11 pm",
#   wednesday_opening_hours: "7 am-11 pm",
#   thursday_opening_hours: "7 am-11 pm",
#   friday_opening_hours: "7 am-11 pm",
#   saturday_opening_hours: "7 am-11 pm",
#   sunday_opening_hours: "11 am-5 pm"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: playgrounds.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: outdoor.id)

# params = {
#   title: "Clissold Park Playground",
#   address: "Clissold Park, Church Street, London N16 9HJ",
#   description: "Very spacious and has the soft flooring. Lots of kids are able to play together or by themselves. There are also benches and seating area to watch the kids. I highly recommend for toddlers to kids to play.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipMtPhk5uGhUjK0n0-tidVLcCn7QP27EAZsHZ6gs",
#   monday_opening_hours: "7:30 am-5:30 pm",
#   tuesday_opening_hours: "7:30 am-5:30 pm",
#   wednesday_opening_hours: "7:30 am-5:30 pm",
#   thursday_opening_hours: "7:30 am-5:30 pm",
#   friday_opening_hours: "7:30 am-5:30 pm",
#   saturday_opening_hours: "7:30 am-5:30 pm",
#   sunday_opening_hours: "7:30 am-5:30 pm"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: playgrounds.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: outdoor.id)

# params = {
#   title: "Kidzmania",
#   address: "28 Powell Rd, Lower Clapton, London E5 8DJ",
#   description: "The food is tasty and well priced. Staff is efficient and helpful. Toilets are clean. What's not to like? We're lucky to have Kidzmania around the corner.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipMEhSRJdPiDFTvNGkvhHOPRFKY6pc-JxbXWngPf",
#   website_url: "http://www.kidzmania.co.uk/",
#   monday_opening_hours: "10 am-3 pm",
#   tuesday_opening_hours: "10 am-3 pm",
#   wednesday_opening_hours: "10 am-3 pm",
#   thursday_opening_hours: "11:30 am-3 pm",
#   friday_opening_hours: "10 am-4 pm",
#   saturday_opening_hours: "10 am-5 pm",
#   sunday_opening_hours: "10 am-5 pm"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: soft_play.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: indoor.id)

# params = {
#   title: "Sobell Leisure Centre",
#   address: "Tollington Rd, London N7 7NY",
#   description: "Huge complex offering indoor & outdoor sports courts, a boxing gym & a fitness centre.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipOGx1tQu97nrLRd0lgn230_WtWQwWct5xaCpC_o",
#   website_url: "https://www.better.org.uk/leisure-centre/london/islington/sobell",
#   monday_opening_hours: "6:30 am-10pm",
#   tuesday_opening_hours: "6:30 am-10pm",
#   wednesday_opening_hours: "6:30 am-10pm",
#   thursday_opening_hours: "6:30 am-10pm",
#   friday_opening_hours: "6:30 am-10pm",
#   saturday_opening_hours: "8 am-6 pm",
#   sunday_opening_hours: "8 am-6 pm"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: soft_play.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: indoor.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: leisure_centres.id)

# params = {
#   title: "Queensbridge Sports and Community Centre",
#   address: "30 Holly St, London E8 3XW",
#   description: "Great soft play on Wednesdays. Plenty of things for the kids, and friendly staff. You can book online as well. They have wheelchair and buggy accessible toilets. And space to park your buggy.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipMme2KGPS3ahxbI3xg-wRLIv41Itaqx8cxxwVdf",
#   website_url: "https://www.better.org.uk/leisure-centre/london/hackney/queensbridge-sport-and-community-centre",
#   monday_opening_hours: "7 am-10 pm",
#   tuesday_opening_hours: "7 am-10 pm",
#   wednesday_opening_hours: "7 am-10 pm",
#   thursday_opening_hours: "7 am-10 pm",
#   friday_opening_hours: "7 am-10 pm",
#   saturday_opening_hours: "9 am-5 pm",
#   sunday_opening_hours: "9 am-5 pm"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: soft_play.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: indoor.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: leisure_centres.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: bouncy_castles.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: gymnastics.id)

# params = {
#   title: "Young V&A",
#   address: "Cambridge Heath Rd, Bethnal Green, London E2 9PA",
#   description: "Toys, clothes and interactives in 1872 hangar with marble floor and visible cast iron skeleton.",
#   photo_url: "https://lh3.googleusercontent.com/gps-proxy/AFm_dcR9oH-OV09K0_efNhKYtkCBcCOpEwQowfZYd4HOJcwWKt4ve3YufrU-CSgzxealj6RouzK9pA2YavE_1pRbFc_y4YHgYmidyD-edVnIZUEfYCdh3fic9SnCWBEVtq7QRvwQdykqeJOvF2zUgCJ1UPc_hZaxQxMJoYaEg6c8SFXyYUvRc5-35wM",
#   website_url: "https://www.vam.ac.uk/young/",
#   monday_opening_hours: "10 am-5:45 pm",
#   tuesday_opening_hours: "10 am-5:45 pm",
#   wednesday_opening_hours: "10 am-5:45 pm",
#   thursday_opening_hours: "10 am-5:45 pm",
#   friday_opening_hours: "10 am-5:45 pm",
#   saturday_opening_hours: "10 am-5:45 pm",
#   sunday_opening_hours: "10 am-5:45 pm"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: museums.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: indoor.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: arts_and_crafts.id)

# # The following activities were created by ChatGPT
# params = {
#   title: "Natural History Museum",
#   address: "Cromwell Rd, Kensington, London SW7 5BD",
#   description: "Explore the wonders of the natural world at the Natural History Museum.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipOMb9YVCox6W-cx9K_cDPtOX-6xOMMCdC1i_E-4",
#   website_url: "https://www.nhm.ac.uk/",
#   monday_opening_hours: "10 am-5:50 pm",
#   tuesday_opening_hours: "10 am-5:50 pm",
#   wednesday_opening_hours: "10 am-5:50 pm",
#   thursday_opening_hours: "10 am-5:50 pm",
#   friday_opening_hours: "10 am-5:50 pm",
#   saturday_opening_hours: "10 am-5:50 pm",
#   sunday_opening_hours: "10 am-5:50 pm"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: museums.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: indoor.id)

# params = {
#   title: "Princess Diana Memorial Playground",
#   address: "Kensington Gardens, London W2 3XA",
#   description: "A magical space for children to play, with a huge wooden pirate ship as the centerpiece. Inspired by the stories of Peter Pan, the playground is designed for children up to 12 years old.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipPDbI2Y7t1Dzby3DZw69klCaO3N8HyiVJhD20kH",
#   website_url: "https://www.royalparks.org.uk/parks/kensington-gardens/things-to-see-and-do/playgrounds-and-gardens/diana-memorial-playground",
#   monday_opening_hours: "10 am-4:45 pm",
#   tuesday_opening_hours: "10 am-4:45 pm",
#   wednesday_opening_hours: "10 am-4:45 pm",
#   thursday_opening_hours: "10 am-4:45 pm",
#   friday_opening_hours: "10 am-4:45 pm",
#   saturday_opening_hours: "10 am-4:45 pm",
#   sunday_opening_hours: "10 am-4:45 pm"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: playgrounds.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: outdoor.id)

# # Additional activity 3
# params = {
#   title: "London Zoo",
#   address: "Regent's Park, London NW1 4RY",
#   description: "Experience a day of fun and excitement with the diverse wildlife at London Zoo.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipOvsMwI0qwIuxMMRFZdCy8U3_NM6y7kE90sZrQ",
#   website_url: "https://www.zsl.org/zsl-london-zoo",
#   monday_opening_hours: "10 am-4 pm",
#   tuesday_opening_hours: "10 am-4 pm",
#   wednesday_opening_hours: "10 am-4 pm",
#   thursday_opening_hours: "10 am-4 pm",
#   friday_opening_hours: "10 am-4 pm",
#   saturday_opening_hours: "10 am-4 pm",
#   sunday_opening_hours: "10 am-4 pm"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: animals.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: outdoor.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: science.id)

# # Additional activity 4
# params = {
#   title: "Little Angel Theatre",
#   address: "14 Dagmar Passage, London N1 2DN",
#   description: "Enjoy puppetry and storytelling at the Little Angel Theatre.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipOLL_4jOMQzXb4a52Fa3DCqkpLHF4a-dVZZs5Ea",
#   website_url: "https://littleangeltheatre.com/",
#   monday_opening_hours: "Closed",
#   tuesday_opening_hours: "10 am-5 pm",
#   wednesday_opening_hours: "10 am-5 pm",
#   thursday_opening_hours: "10 am-5 pm",
#   friday_opening_hours: "10 am-5 pm",
#   saturday_opening_hours: "10 am-5 pm",
#   sunday_opening_hours: "Closed"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: theatre.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: indoor.id)

# # Additional activity 5
# params = {
#   title: "Mudchute Park and Farm",
#   address: "Pier St, Isle of Dogs, London E14 3HP",
#   description: "Experience farm life in the heart of London at Mudchute Park and Farm.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipPjyipxSbXdOYQX1L66V6cCS-QAUJMcGH7BFn4L",
#   website_url: "https://www.mudchute.org/",
#   monday_opening_hours: "9 am-4 pm",
#   tuesday_opening_hours: "9 am-4 pm",
#   wednesday_opening_hours: "9 am-4 pm",
#   thursday_opening_hours: "9 am-4 pm",
#   friday_opening_hours: "9 am-4 pm",
#   saturday_opening_hours: "9 am-4 pm",
#   sunday_opening_hours: "9 am-4 pm"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: farms.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: outdoor.id)

# # Additional activity 6
# params = {
#   title: "Science Museum",
#   address: "Exhibition Rd, South Kensington, London SW7 2DD",
#   description: "Explore the wonders of science at the Science Museum in South Kensington.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipNSvECAgTZSjYmTl4_XlDmoEj0fSr8vVXqmB7Br",
#   website_url: "https://www.sciencemuseum.org.uk/",
#   monday_opening_hours: "10 am-6 pm",
#   tuesday_opening_hours: "10 am-6 pm",
#   wednesday_opening_hours: "10 am-6 pm",
#   thursday_opening_hours: "10 am-6 pm",
#   friday_opening_hours: "10 am-6 pm",
#   saturday_opening_hours: "10 am-6 pm",
#   sunday_opening_hours: "10 am-6 pm"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: museums.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: indoor.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: science.id)

# params = {
#   title: "Hackney City Farm",
#   address: "1a Goldsmiths Row, London E2 8QA",
#   description: "A city farm offering a chance for kids to interact with a variety of animals, including goats, pigs, chickens, and more. Educational and enjoyable for the whole family.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipMnKTsIt1MJH7J6UorSeq7yrRHo3xrLeggL_iw",
#   website_url: "https://hackneycityfarm.co.uk/",
#   monday_opening_hours: "10 am-4 pm",
#   tuesday_opening_hours: "10 am-4 pm",
#   wednesday_opening_hours: "10 am-4 pm",
#   thursday_opening_hours: "10 am-4 pm",
#   friday_opening_hours: "10 am-4 pm",
#   saturday_opening_hours: "10 am-4 pm",
#   sunday_opening_hours: "10 am-4 pm"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: farms.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: outdoor.id)

# params = {
#   title: "Kidspace Romford",
#   address: "Thurloe Ave, Hornchurch RM11 2AB",
#   description: "An indoor adventure park featuring various play areas, slides, and activities for children of different ages. Great for energetic and playful kids.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipNWpVkl-aG_Gka5I3DtRFRoJmCOWvzMVYsGhMlt",
#   website_url: "https://www.kidspaceadventures.com/romford",
#   monday_opening_hours: "10 am-6 pm",
#   tuesday_opening_hours: "10 am-6 pm",
#   wednesday_opening_hours: "10 am-6 pm",
#   thursday_opening_hours: "10 am-6 pm",
#   friday_opening_hours: "10 am-6 pm",
#   saturday_opening_hours: "9:30 am-7 pm",
#   sunday_opening_hours: "9:30 am-7 pm"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: play_cafe.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: soft_play.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: indoor.id)

# params = {
#   title: "Artburst",
#   address: "St Matthias Hall, Wordsworth Road, London N16 8DD",
#   description: "Artburst offers creative arts classes for children, including painting, drawing, and crafts. A fun and educational experience for young artists.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipOdE07_yr9Yt0h_m9_3x8ul4p05loCEP9FrYYlW",
#   website_url: "https://artburst.co.uk/",
#   monday_opening_hours: "Varies (check website for schedule)",
#   tuesday_opening_hours: "Varies (check website for schedule)",
#   wednesday_opening_hours: "Varies (check website for schedule)",
#   thursday_opening_hours: "Varies (check website for schedule)",
#   friday_opening_hours: "Varies (check website for schedule)",
#   saturday_opening_hours: "Varies (check website for schedule)",
#   sunday_opening_hours: "Varies (check website for schedule)"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: arts_and_crafts.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: indoor.id)

# params = {
#   title: "Rich Mix",
#   address: "35-47 Bethnal Green Rd, London E1 6LA",
#   description: "Rich Mix is a cultural and arts venue offering a diverse range of performances, exhibitions, and workshops. Check their schedule for family-friendly events.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipPsUMxryo-NIPHnv2JNQsq4aM8vdhVZnPqvAbns",
#   website_url: "https://www.richmix.org.uk/",
#   monday_opening_hours: "Varies (check website for schedule)",
#   tuesday_opening_hours: "Varies (check website for schedule)",
#   wednesday_opening_hours: "Varies (check website for schedule)",
#   thursday_opening_hours: "Varies (check website for schedule)",
#   friday_opening_hours: "Varies (check website for schedule)",
#   saturday_opening_hours: "Varies (check website for schedule)",
#   sunday_opening_hours: "Varies (check website for schedule)"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: arts_and_crafts.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: theatre.id)

# params = {
#   title: "Hampstead Heath",
#   address: "Highgate Rd, London NW3 7JR",
#   description: "Hampstead Heath is a large, beautiful park offering natural landscapes, playgrounds, and outdoor activities. Perfect for a day of family fun in nature.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipMVfs7mWeJZsyU-8FiNRnOINXOQE86Kj7pI6YZm",
#   website_url: "https://www.cityoflondon.gov.uk/things-to-do/green-spaces/hampstead-heath",
#   monday_opening_hours: "Open 24 hours",
#   tuesday_opening_hours: "Open 24 hours",
#   wednesday_opening_hours: "Open 24 hours",
#   thursday_opening_hours: "Open 24 hours",
#   friday_opening_hours: "Open 24 hours",
#   saturday_opening_hours: "Open 24 hours",
#   sunday_opening_hours: "Open 24 hours"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: outdoor.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: adventure_playgrounds.id)

# params = {
#   title: "The Royal Observatory",
#   address: "Blackheath Ave, London SE10 8XJ",
#   description: "Explore astronomy and stand on the Prime Meridian at the Royal Observatory. Educational and fascinating for both kids and adults.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipMWcnEs7LsaW0-K-YlPXaXCTon3oNBL5hiZBk4U",
#   website_url: "https://www.rmg.co.uk/royal-observatory",
#   monday_opening_hours: "10 am-5 pm",
#   tuesday_opening_hours: "10 am-5 pm",
#   wednesday_opening_hours: "10 am-5 pm",
#   thursday_opening_hours: "10 am-5 pm",
#   friday_opening_hours: "10 am-5 pm",
#   saturday_opening_hours: "10 am-5 pm",
#   sunday_opening_hours: "10 am-5 pm"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: museums.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: indoor.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: science.id)

# params = {
#   title: "The Little Gym of Wandsworth & Fulham",
#   address: "7 Frogmore, Wandsworth, London SW18 1HW",
#   description: "The Little Gym offers classes for kids to develop physical and social skills through fun and engaging activities. A great place for active play and learning.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipNBnLVdOtY8Bq6sFG-FTTTPEs64hzglJx45mdME",
#   website_url: "https://www.thelittlegym.eu/wandsworthfulham",
#   monday_opening_hours: "9 am-7:30 pm",
#   tuesday_opening_hours: "9 am-7:30 pm",
#   wednesday_opening_hours: "9 am-8:30 pm",
#   thursday_opening_hours: "9 am-7:30 pm",
#   friday_opening_hours: "9 am-7:30 pm",
#   saturday_opening_hours: "9 am-6 pm",
#   sunday_opening_hours: "9 am-6 pm"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: gymnastics.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: indoor.id)

# params = {
#   title: "Toconoco",
#   address: "28 Hertford Rd, London N1 5QT",
#   description: "Japanese snacks, meals & teas offered in a colourful, canal-side cafe with a play room for kids.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipPBItnGzn2n6zvp8J_w30bOCtSn7OUtar9zdHym",
#   website_url: "https://www.toconoco.com/",
#   monday_opening_hours: "9 am-6 pm",
#   tuesday_opening_hours: "9 am-6 pm",
#   wednesday_opening_hours: "9 am-6 pm",
#   thursday_opening_hours: "9 am-6 pm",
#   friday_opening_hours: "9 am-6 pm",
#   saturday_opening_hours: "9 am-6 pm",
#   sunday_opening_hours: "Closed"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: play_cafe.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: indoor.id)

# # Activity 18
# params = {
#   title: "The Postal Museum",
#   address: "15-20 Phoenix Pl, London WC1X 0DA",
#   description: "Explore the fascinating history of postal services at the Postal Museum. Fun exhibits and interactive displays make it an engaging experience for all ages.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipPk0MhLd4OUIB7e48pZyQdkSQdNz4FdYQUg3S4J",
#   website_url: "https://www.postalmuseum.org/",
#   monday_opening_hours: "10 am-5 pm",
#   tuesday_opening_hours: "10 am-5 pm",
#   wednesday_opening_hours: "10 am-5 pm",
#   thursday_opening_hours: "10 am-5 pm",
#   friday_opening_hours: "10 am-5 pm",
#   saturday_opening_hours: "10 am-5 pm",
#   sunday_opening_hours: "10 am-5 pm"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: museums.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: indoor.id)

# # Activity 19
# params = {
#   title: "Victoria Park Main Playground",
#   address: "Victoria Park, London E9 5DU",
#   description: "The playground is situated in the middle of the park next to the lake, it is equipped with many different kiddie facilities, slides, swings, tree houses, dragon swing, sand pits.

#   The playground is well maintained. The kids and parents there are friendly. It is definitely one of the best playgrounds in East London.",
#   photo_url: "https://lh5.googleusercontent.com/p/AF1QipN4aubyicc_3ytS5k-PNF2ccl3yJGJPzUfDCaKO",
#   monday_opening_hours: "7 am-11 pm",
#   tuesday_opening_hours: "7 am-11 pm",
#   wednesday_opening_hours: "7 am-11 pm",
#   thursday_opening_hours: "7 am-11 pm",
#   friday_opening_hours: "7 am-11 pm",
#   saturday_opening_hours: "7 am-11 pm",
#   sunday_opening_hours: "11 am-5 pm"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: playgrounds.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: outdoor.id)

# params = {
#   title: "King Henry's Walk Adventure Playground",
#   address: "11 King Henry's Walk, London N1 4NX",
#   description: "Great informal and friendly place for kids to play.  Active outdoor space, cooking, craft, chilling.  Just what kids need after school.",
#   photo_url: "https://awesomeadventureplay.org/wp-content/uploads/2019/10/khw4-1000x500.jpg",
#   website_url: "https://awesomeadventureplay.org/playgrounds/king-henrys-walk/",
#   monday_opening_hours: "3:30-6:30 pm",
#   tuesday_opening_hours: "3:30-6:30 pm",
#   wednesday_opening_hours: "3:30-6:30 pm",
#   thursday_opening_hours: "3:30-6:30 pm",
#   friday_opening_hours: "3:30-6:30 pm",
#   saturday_opening_hours: "10:30 am-6:30 pm",
#   sunday_opening_hours: "Closed"
# }
# new_activity = Activity.create(params)

# ActivityCategory.create(activity_id: new_activity.id, category_id: adventure_playgrounds.id)
# ActivityCategory.create(activity_id: new_activity.id, category_id: outdoor.id)

# end ChatGPT

puts "Successfully created #{Activity.all.count} activities."

puts "Seeding the database with new encounters for the first user..."

user = User.first

a = Encounter.create(user_id: user.id, activity_id: Activity.all[0].id)
b = Encounter.create(user_id: user.id, activity_id: Activity.all[1].id)
c = Encounter.create(user_id: user.id, activity_id: Activity.all[2].id)

puts "Successfully created three encounters."

puts "Giving the user a new collection..."

collection = Collection.create(user_id: user.id, title: "Half-term activities")
EncounterCollection.create(collection_id: collection.id, encounter_id: a.id)
EncounterCollection.create(collection_id: collection.id, encounter_id: b.id)
EncounterCollection.create(collection_id: collection.id, encounter_id: c.id)

puts "There are #{collection.activities.count} activities in this collection."

puts "Finished seeding!"
