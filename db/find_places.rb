require 'open-uri'
require 'json'

api_key = ENV['GOOGLEMAPS_API_KEY']
# will have to actually supply the api key

stay_and_play = [
  "ALL ABOARD TRAIN PLAY",
  "ALL SOULS CHURCH LANGHAM PLACE",
  "BABY HUB",
  "BABY SENSORY",
  "BARNES SPORTS CLUB",
  "BUNNYKIDSPLAYGROUP",
  "CARNEGIE LIBRARY UPPER NORWOOD AND WATERLOO",
  "CHATTERBOX",
  "Christ Church Kensington",
  "CHRIST CHURCH LONDON",
  "CHRIST CHURCH SPITALFIELDS",
  "Christ Church Spitalfields",
  "CHRYSALIS MONTESSORI",
  "Clapham Park Cube",
  "CREATIVE BRICKS CLUB",
  "EMMANUEL CHURCH",
  "Emmanuel Holloway",
  "Fitzrovia Community Centre",
  "Goodinge Community Centre",
  "GREENWICH ACORNS",
  "Gymboree Play & Music East Dulwich",
  "Hargrave Hall Community Centre",
  "Inspire Saint James Church",
  "INSPIRE STAY AND PLAY",
  "Islington Dance Studios",
  "JUMP&PLAY",
  "Larkhall Family Centre",
  "Liverpool Road Community Centre",
  "NORTH LONDON RUDOLF STEINER SCHOOL",
  "Off The Rails",
  "PASITOS LONDON",
  "PENNY POPPINS - MESSY PLAY",
  "Red & Black Club",
  "Saint Georges Church",
  "SAMMY'S SOFT PLAY",
  "ST GEORGE'S CHURCH, TUFNELL PARK",
  "St James-the-Less Church, Bethnal Green",
  "St Johns Hill URC, Sevenoaks",
  "St Luke's Church of England, Battersea.",
  "St Mark's Church, Clerkenwell",
  "ST MARY'S PRIORY INFANT AND JUNIOR SCHOOLS",
  "St Paul's Shadwell",
  "ST STEPHEN'S CHURCH PADDINGTON",
  "St. Hilda's East Community Centre",
  "T & FI SOFT PLAY",
  "The City Dance Academy",
  "The Dockland Settlement Community Centre 400 Salter Rd",
  "TOYHOUSE",
  "TRINITY CHURCH ISLINGTON",
  "WESLEY'S CHAPEL AND LEYSIAN MISSION",
  "YMCA LONDON CITY AND NORTH",
  "Yogaloft Studios",
  "London Museum of Water & Steam",
  "Storkway Children's Centre",
  "Shooters Hill Children's Centre",
  "Vista Field Children's Centre",
  "Eltham Children's Centre",
  "Greenacres Children's Centre",
  "Discovery Children's Centre, Thamesmead",
  "Alderwood Children's Centre",
  "Waterways Children's Centre, Thamesmead",
  "Abbey Wood Children's Centre",
  "Mulberry Park Children's Centre",
  "Maples Nursery School and Children's Centre",
  "Brookhill Nursery School and Children's Centre"
]
category = "stay and play"
stay_and_play.each do |activity|
  file_path = "db/files/#{activity}.json"
  if File.exists?(file_path)
    # TODO: Open the file and read its contents, add category
    file_contents = File.read(file_path)
    data = JSON.parse(file_contents)
    data['categories'] ||= [] # Ensure 'categories' key exists
    unless data['categories'].include?(category)
      data['categories'] << category
      puts "Added '#{category}' to the categories in #{activity}.json"
    end
    unless data['address']
      #make_api_call
      url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cplace_id"
      response = URI.open(url).read
      result = JSON.parse(response)
      if result["candidates"].length > 0
        address = result["candidates"][0]["formatted_address"]
        formatted_address = result["candidates"][0]["formatted_address"]
      end
      if address
        data['address'] = address
        p "Updating the address for #{activity}"
      else
        p "Unable to find an address for #{activity}"
      end
    end
    updated_contents = JSON.generate(data)
    File.open(file_path, 'w') { |file| file.write(updated_contents) }
  else
    # make an initial query to get the place_i
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cname%2Crating%2Cplace_id%2Copening_hours%2Cgeometry"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["candidates"].length > 0
      place_id = result["candidates"][0]["place_id"]
      formatted_address = result["candidates"][0]["formatted_address"]
      url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Creviews%2Cuser_ratings_total%2Ceditorial_summary%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cgeometry%2Cphoto&place_id=#{place_id}&key=#{api_key}"
      response = URI.open(url).read
      result = JSON.parse(response)
      result["place_id"] = place_id
      result["address"] = formatted_address
      result["categories"] = ["stay and play"]
      p result["result"]["name"]
      File.open("db/files/#{activity}.json", "wb") do |f|
        f << JSON.generate(result)
      end
    end
    #sleep to avoid spamming the API
    # sleep(0.1)
  end
end

museums = [
  "Churchill Museum and Cabinet War Rooms",
  "Harry Potter Tour: (Warner Bros. Studio Tour - The Making of Harry Potter)",
  "Household Cavalry Museum",
  "Shri Swaminarayan Mandir",
  "Foundling Museum",
  "Old Operating Theatre Museum & Herb Garret",
  "Sherlock Holmes Museum",
  "O2",
  "Clink Prison Museum",
  "Museum of the Home",
  "Horniman Museum and Gardens",
  "Royal Observatory Greenwich",
  "British Library",
  "Tate Britain",
  "Royal Academy of Arts",
  "Ripley's Believe It or Not! London",
  "Tower Bridge Exhibition & Walkway",
  "Emirates Stadium Tour & Arsenal Museum",
  "Science Museum",
  "RAF Museum",
  "Victoria and Albert Museum",
  "Chelsea F.C. Stadium Tour and Museum",
  "Wimbledon Lawn Tennis Museum",
  "Museum of London",
  "Museum of Childhood",
  "Imperial War Museum",
  "National Maritime Museum",
  "London Transport Museum",
  "Natural History Museum",
  "London Transport Museum Depot",
  "Kew Gardens",
  "HMS Belfast",
  "British Museum",
  "Madame Tussauds London",
  "London Museum of Water & Steam",
  "National Army Museum",
  "Discover Children's Story Centre",
  "Hackney Museum",
  "Museum of London Docklands",
  "London Children's Museum"
]
category = "museums"
museums.each do |activity|
  file_path = "db/files/#{activity}.json"
  if File.exists?(file_path)
    # TODO: Open the file and read its contents, add category
    file_contents = File.read(file_path)
    data = JSON.parse(file_contents)
    data['categories'] ||= [] # Ensure 'categories' key exists
    unless data['categories'].include?(category)
      data['categories'] << category
      puts "Added '#{category}' to the categories in #{activity}.json"
    end
    unless data['address']
      #make_api_call
      url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cplace_id"
      response = URI.open(url).read
      result = JSON.parse(response)
      if result["candidates"].length > 0
        address = result["candidates"][0]["formatted_address"]
        formatted_address = result["candidates"][0]["formatted_address"]
      end
      if address
        data['address'] = address
        p "Updating the address for #{activity}"
      else
        p "Unable to find an address for #{activity}"
      end
    end
    updated_contents = JSON.generate(data)
    File.open(file_path, 'w') { |file| file.write(updated_contents) }
  else
    # make an initial query to get the place_id
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cname%2Crating%2Cplace_id%2Copening_hours%2Cgeometry"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["candidates"].length > 0
      place_id = result["candidates"][0]["place_id"]
      formatted_address = result["candidates"][0]["formatted_address"]
      url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Creviews%2Cuser_ratings_total%2Ceditorial_summary%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cgeometry%2Cphoto&place_id=#{place_id}&key=#{api_key}"
      response = URI.open(url).read
      result = JSON.parse(response)
      result["place_id"] = place_id
      result["address"] = formatted_address
      result["categories"] = ["#{category}"]
      p result["result"]["name"]
      File.open("db/files/#{activity}.json", "wb") do |f|
        f << JSON.generate(result)
      end
    end
    #sleep to avoid spamming the API
    # sleep(0.1)
  end
end

outdoor = [
  "Paradise Wildlife Park",
  "WWT London Wetland Centre",
  "Richmond Park - Isabella Plantation",
  "Queen Elizabeth Olympic Park",
  "Hampstead Heath",
  "Horniman Museum and Gardens",
  "Osterley Park and House",
  "Winter Wonderland",
  "Victoria Park",
  "Hackney City Farm",
  "Kensington Gardens",
  "Hyde Park",
  "Kenwood House",
  "Queen's Park",
  "Queen's Park Pitch and Putt",
  "Hampstead Heath Mixed Bathing Pond",
  "Welsh Harp Reservoir",
  "Kew Gardens",
  "New River Walk",
  "King Henry's Walk Garden",
  "Woodberry Wetlands, London Wildlife Trust"
]
category = "outdoor"
outdoor.each do |activity|
  file_path = "db/files/#{activity}.json"
  if File.exists?(file_path)
    # TODO: Open the file and read its contents, add category
    file_contents = File.read(file_path)
    data = JSON.parse(file_contents)
    data['categories'] ||= [] # Ensure 'categories' key exists
    unless data['categories'].include?(category)
      data['categories'] << category
      puts "Added '#{category}' to the categories in #{activity}.json"
    end
    unless data['address']
      #make_api_call
      url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cplace_id"
      response = URI.open(url).read
      result = JSON.parse(response)
      if result["candidates"].length > 0
        address = result["candidates"][0]["formatted_address"]
        formatted_address = result["candidates"][0]["formatted_address"]
      end
      if address
        data['address'] = address
        p "Updating the address for #{activity}"
      else
        p "Unable to find an address for #{activity}"
      end
    end
    updated_contents = JSON.generate(data)
    File.open(file_path, 'w') { |file| file.write(updated_contents) }
  else
    # make an initial query to get the place_i
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cname%2Crating%2Cplace_id%2Copening_hours%2Cgeometry"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["candidates"].length > 0
      place_id = result["candidates"][0]["place_id"]
      formatted_address = result["candidates"][0]["formatted_address"]
      url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Creviews%2Cuser_ratings_total%2Ceditorial_summary%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cgeometry%2Cphoto&place_id=#{place_id}&key=#{api_key}"
      response = URI.open(url).read
      result = JSON.parse(response)
      result["place_id"] = place_id
      result["address"] = formatted_address
      result["categories"] = ["#{category}"]
      p result["result"]["name"]
      File.open("db/files/#{activity}.json", "wb") do |f|
        f << JSON.generate(result)
      end
    end
    #sleep to avoid spamming the API
    # sleep(0.1)
  end
end

historic = [
  "The Ghost Bus Tours",
  "Churchill Museum and Cabinet War Rooms",
  "Cutty Sark",
  "Household Cavalry Museum",
  "Trafalgar Square",
  "Foundling Museum",
  "Old Operating Theatre Museum & Herb Garret",
  "Medieval Banquet",
  "Golden Hinde",
  "Clink Prison Museum",
  "Southwark Cathedral",
  "Wallace Collection",
  "Royal Observatory Greenwich",
  "Old Royal Naval College",
  "British Library",
  "Osterley Park and House",
  "Westminster Abbey",
  "Kew Palace",
  "Shakespeare's Globe Exhibition and Tour",
  "The State Rooms Buckingham Palace",
  "St Paul's Cathedral",
  "Eltham Palace",
  "Houses of Parliament: Family Audio Tour",
  "Royal Albert Hall",
  "Tower Bridge Exhibition & Walkway",
  "Tower Of London",
  "London Dungeon",
  "Museum of London",
  "Horse Guards Parade",
  "London Bridge Experience",
  "Kensington Palace",
  "Hampton Court Palace",
  "HMS Belfast",
  "Monument to the Great Fire of London"
]
category = "historic"
historic.each do |activity|
  file_path = "db/files/#{activity}.json"
  if File.exists?(file_path)
    # TODO: Open the file and read its contents, add category
    file_contents = File.read(file_path)
    data = JSON.parse(file_contents)
    data['categories'] ||= [] # Ensure 'categories' key exists
    unless data['categories'].include?(category)
      data['categories'] << category
      puts "Added '#{category}' to the categories in #{activity}.json"
    end
    unless data['address']
      #make_api_call
      url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cplace_id"
      response = URI.open(url).read
      result = JSON.parse(response)
      if result["candidates"].length > 0
        address = result["candidates"][0]["formatted_address"]
        formatted_address = result["candidates"][0]["formatted_address"]
      end
      if address
        data['address'] = address
        p "Updating the address for #{activity}"
      else
        p "Unable to find an address for #{activity}"
      end
    end
    updated_contents = JSON.generate(data)
    File.open(file_path, 'w') { |file| file.write(updated_contents) }
  else
    # make an initial query to get the place_i
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cname%2Crating%2Cplace_id%2Copening_hours%2Cgeometry"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["candidates"].length > 0
      place_id = result["candidates"][0]["place_id"]
      formatted_address = result["candidates"][0]["formatted_address"]
      url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Creviews%2Cuser_ratings_total%2Ceditorial_summary%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cgeometry%2Cphoto&place_id=#{place_id}&key=#{api_key}"
      response = URI.open(url).read
      result = JSON.parse(response)
      result["place_id"] = place_id
      result["address"] = formatted_address
      result["categories"] = ["#{category}"]
      p result["result"]["name"]
      File.open("db/files/#{activity}.json", "wb") do |f|
        f << JSON.generate(result)
      end
    end
    #sleep to avoid spamming the API
    # sleep(0.1)
  end
end

theatre = [
  "Little Angel Theatre",
  "Lyric Hammersmith",
  "Polka Theatre",
  "Artsdepot",
  "Unicorn Theatre",
  "Lyric Theatre",
  "The London Coliseum",
  "Leicester Square Theatre",
  "Royal Opera House",
  "Garrick Theatre",
  "Theatre Royal Haymarket",
  "Arts Theatre",
  "St. Martin's Theatre",
  "Peacock Theatre",
  "London Palladium",
  "Wilton's Music Hall",
  "Lyric Hammersmith",
  "Hackney Empire",
  "Theatre Royal Stratford East",
  "Richmond Theatre"
]
category = "theatre"
theatre.each do |activity|
  file_path = "db/files/#{activity}.json"
  if File.exists?(file_path)
    # TODO: Open the file and read its contents, add category
    file_contents = File.read(file_path)
    data = JSON.parse(file_contents)
    data['categories'] ||= [] # Ensure 'categories' key exists
    unless data['categories'].include?(category)
      data['categories'] << category
      puts "Added '#{category}' to the categories in #{activity}.json"
    end
    unless data['address']
      #make_api_call
      url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cplace_id"
      response = URI.open(url).read
      result = JSON.parse(response)
      if result["candidates"].length > 0
        address = result["candidates"][0]["formatted_address"]
        formatted_address = result["candidates"][0]["formatted_address"]
      end
      if address
        data['address'] = address
        p "Updating the address for #{activity}"
      else
        p "Unable to find an address for #{activity}"
      end
    end
    updated_contents = JSON.generate(data)
    File.open(file_path, 'w') { |file| file.write(updated_contents) }
  else
    # make an initial query to get the place_i
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cname%2Crating%2Cplace_id%2Copening_hours%2Cgeometry"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["candidates"].length > 0
      place_id = result["candidates"][0]["place_id"]
      formatted_address = result["candidates"][0]["formatted_address"]
      url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Creviews%2Cuser_ratings_total%2Ceditorial_summary%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cgeometry%2Cphoto&place_id=#{place_id}&key=#{api_key}"
      response = URI.open(url).read
      result = JSON.parse(response)
      result["place_id"] = place_id
      result["address"] = formatted_address
      result["categories"] = ["#{category}"]
      p result["result"]["name"]
      File.open("db/files/#{activity}.json", "wb") do |f|
        f << JSON.generate(result)
      end
    end
    #sleep to avoid spamming the API
    # sleep(0.1)
  end
end

arts_and_crafts = [
  "Wallace Collection",
  "Tate Britain",
  "Royal Academy of Arts",
  "Saatchi Gallery",
  "Courtauld Gallery",
  "Kenwood House",
  "Serpentine Gallery",
  "Victoria and Albert Museum",
  "National Gallery",
  "National Portrait Gallery",
  "Tate Modern"
]
category = "arts and crafts"
arts_and_crafts.each do |activity|
  file_path = "db/files/#{activity}.json"
  if File.exists?(file_path)
    # TODO: Open the file and read its contents, add category
    file_contents = File.read(file_path)
    data = JSON.parse(file_contents)
    data['categories'] ||= [] # Ensure 'categories' key exists
    unless data['categories'].include?(category)
      data['categories'] << category
      puts "Added '#{category}' to the categories in #{activity}.json"
    end
    unless data['address']
      #make_api_call
      url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cplace_id"
      response = URI.open(url).read
      result = JSON.parse(response)
      if result["candidates"].length > 0
        address = result["candidates"][0]["formatted_address"]
        formatted_address = result["candidates"][0]["formatted_address"]
      end
      if address
        data['address'] = address
        p "Updating the address for #{activity}"
      else
        p "Unable to find an address for #{activity}"
      end
    end
    updated_contents = JSON.generate(data)
    File.open(file_path, 'w') { |file| file.write(updated_contents) }
  else
    # make an initial query to get the place_i
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cname%2Crating%2Cplace_id%2Copening_hours%2Cgeometry"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["candidates"].length > 0
      place_id = result["candidates"][0]["place_id"]
      formatted_address = result["candidates"][0]["formatted_address"]
      url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Creviews%2Cuser_ratings_total%2Ceditorial_summary%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cgeometry%2Cphoto&place_id=#{place_id}&key=#{api_key}"
      response = URI.open(url).read
      result = JSON.parse(response)
      result["place_id"] = place_id
      result["address"] = formatted_address
      result["categories"] = ["#{category}","museums"]
      p result["result"]["name"]
      File.open("db/files/#{activity}.json", "wb") do |f|
        f << JSON.generate(result)
      end
    end
    #sleep to avoid spamming the API
    # sleep(0.1)
  end
end

theme_parks = [
  "Shrek's Adventure",
  "KidZania London",
  "Winter Wonderland",
  "Adrenalin Rush Laser Combat",
  "Thorpe Park",
  "Legoland Windsor",
  "Chessington World of Adventures"
]
category = "theme parks"
theme_parks.each do |activity|
  file_path = "db/files/#{activity}.json"
  if File.exists?(file_path)
    # TODO: Open the file and read its contents, add category
    file_contents = File.read(file_path)
    data = JSON.parse(file_contents)
    data['categories'] ||= [] # Ensure 'categories' key exists
    unless data['categories'].include?(category)
      data['categories'] << category
      puts "Added '#{category}' to the categories in #{activity}.json"
    end
    unless data['address']
      #make_api_call
      url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cplace_id"
      response = URI.open(url).read
      result = JSON.parse(response)
      if result["candidates"].length > 0
        address = result["candidates"][0]["formatted_address"]
        formatted_address = result["candidates"][0]["formatted_address"]
      end
      if address
        data['address'] = address
        p "Updating the address for #{activity}"
      else
        p "Unable to find an address for #{activity}"
      end
    end
    updated_contents = JSON.generate(data)
    File.open(file_path, 'w') { |file| file.write(updated_contents) }
  else
    # make an initial query to get the place_i
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cname%2Crating%2Cplace_id%2Copening_hours%2Cgeometry"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["candidates"].length > 0
      place_id = result["candidates"][0]["place_id"]
      formatted_address = result["candidates"][0]["formatted_address"]
      url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Creviews%2Cuser_ratings_total%2Ceditorial_summary%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cgeometry%2Cphoto&place_id=#{place_id}&key=#{api_key}"
      response = URI.open(url).read
      result = JSON.parse(response)
      result["place_id"] = place_id
      result["address"] = formatted_address
      result["categories"] = ["#{category}"]
      p result["result"]["name"]
      File.open("db/files/#{activity}.json", "wb") do |f|
        f << JSON.generate(result)
      end
    end
    #sleep to avoid spamming the API
    # sleep(0.1)
  end
end

sports = [
  "DNA VR",
  "All Star Lanes",
  "Oxygen Freejumping",
  "BFI IMAX",
  "Richmond Park - Isabella Plantation",
  "Natural History Museum Ice Rink",
  "Bay Sixty6",
  "Hammersmith BMX Track",
  "Hemel Hempstead Snow Centre",
  "Lee Valley White Water Centre",
  "QUEENS skate dine bowl"
]
category = "sports"
sports.each do |activity|
  file_path = "db/files/#{activity}.json"
  if File.exists?(file_path)
    # TODO: Open the file and read its contents, add category
    file_contents = File.read(file_path)
    data = JSON.parse(file_contents)
    data['categories'] ||= [] # Ensure 'categories' key exists
    unless data['categories'].include?(category)
      data['categories'] << category
      puts "Added '#{category}' to the categories in #{activity}.json"
    end
    unless data['address']
      #make_api_call
      url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cplace_id"
      response = URI.open(url).read
      result = JSON.parse(response)
      if result["candidates"].length > 0
        address = result["candidates"][0]["formatted_address"]
        formatted_address = result["candidates"][0]["formatted_address"]
      end
      if address
        data['address'] = address
        p "Updating the address for #{activity}"
      else
        p "Unable to find an address for #{activity}"
      end
    end
    updated_contents = JSON.generate(data)
    File.open(file_path, 'w') { |file| file.write(updated_contents) }
  else
    # make an initial query to get the place_i
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cname%2Crating%2Cplace_id%2Copening_hours%2Cgeometry"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["candidates"].length > 0
      place_id = result["candidates"][0]["place_id"]
      formatted_address = result["candidates"][0]["formatted_address"]
      url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Creviews%2Cuser_ratings_total%2Ceditorial_summary%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cgeometry%2Cphoto&place_id=#{place_id}&key=#{api_key}"
      response = URI.open(url).read
      result = JSON.parse(response)
      result["place_id"] = place_id
      result["address"] = formatted_address
      result["categories"] = ["#{category}"]
      p result["result"]["name"]
      File.open("db/files/#{activity}.json", "wb") do |f|
        f << JSON.generate(result)
      end
    end
    #sleep to avoid spamming the API
    # sleep(0.1)
  end
end


animals = [
  "Paradise Wildlife Park",
  "WWT London Wetland Centre",
  "Spitalfields City Farm",
  "Hackney City Farm",
  "London Zoo",
  "Sea Life London Aquarium"
]
category = "animals"
animals.each do |activity|
  file_path = "db/files/#{activity}.json"
  if File.exists?(file_path)
    # TODO: Open the file and read its contents, add category
    file_contents = File.read(file_path)
    data = JSON.parse(file_contents)
    data['categories'] ||= [] # Ensure 'categories' key exists
    unless data['categories'].include?(category)
      data['categories'] << category
      puts "Added '#{category}' to the categories in #{activity}.json"
    end
    unless data['address']
      #make_api_call
      url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cplace_id"
      response = URI.open(url).read
      result = JSON.parse(response)
      if result["candidates"].length > 0
        address = result["candidates"][0]["formatted_address"]
        formatted_address = result["candidates"][0]["formatted_address"]
      end
      if address
        data['address'] = address
        p "Updating the address for #{activity}"
      else
        p "Unable to find an address for #{activity}"
      end
    end
    updated_contents = JSON.generate(data)
    File.open(file_path, 'w') { |file| file.write(updated_contents) }
  else
    # make an initial query to get the place_i
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cname%2Crating%2Cplace_id%2Copening_hours%2Cgeometry"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["candidates"].length > 0
      place_id = result["candidates"][0]["place_id"]
      formatted_address = result["candidates"][0]["formatted_address"]
      url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Creviews%2Cuser_ratings_total%2Ceditorial_summary%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cgeometry%2Cphoto&place_id=#{place_id}&key=#{api_key}"
      response = URI.open(url).read
      result = JSON.parse(response)
      result["place_id"] = place_id
      result["address"] = formatted_address
      result["categories"] = ["#{category}"]
      p result["result"]["name"]
      File.open("db/files/#{activity}.json", "wb") do |f|
        f << JSON.generate(result)
      end
    end
    #sleep to avoid spamming the API
    # sleep(0.1)
  end
end


winter_holidays = [
  "Alexandra Palace Ice Rink",
  "All Souls Christmas Carols and Orchestra",
  "An Audience with Father Christmas at Kenwood House",
  "Arts Theatre",
  "B Bakery Afternoon Tea bus tour",
  "Battersea Dogs & Cats Home's Carol Concert",
  "Charles Dickens' Bloomsbury townhouse",
  "Charlie and the Chocolate Factory afternoon tea",
  "Christmas at Eltham Palace",
  "Christmas at Kew",
  "Christmas at the London Transport Museum",
  "Covent Garden Christmas Village",
  "Eventim Apollo",
  "Father Christmas Storytelling at Chelsea Physic Garden",
  "Garrick Theatre",
  "Glide at Battersea Power Station",
  "Greenwich Market Grotto",
  "Hackney Empire",
  "Hamley's Grotto",
  "Hampton Court Palace",
  "Harrods",
  "Hogwarts in the Snow",
  "Ice Rink Canary Wharf",
  "Kenwood House",
  "Kew",
  "King's Cross and Coal Drops Yard",
  "Kingdom of Winter",
  "Kingdom of Winter",
  "Leicester Square",
  "Leicester Square Christmas Market",
  "Leicester Square Theatre",
  "London Palladium",
  "London Zoo",
  "London Zoo",
  "Lyric Hammersmith",
  "Lyric Theatre",
  "Marriott Grosvenor House",
  "Peacock Theatre",
  "Postal Museum",
  "Queen's House Ice Rink in Greenwich",
  "Queen's Skate Dine Bowl",
  "Richmond Theatre",
  "Royal Albert Hall",
  "Royal Albert Hall's 'Films in Concert'",
  "Royal Opera House",
  "Santa Land at Winter Wonderland Hyde Park",
  "Santa's Grotto at Alexandra Palace",
  "Shard Lights",
  "Skate at Somerset House",
  "Skate West End",
  "Skylight London Ice Rink in Tobacco Dock",
  "Southbank Centre Winter Market",
  "Sparkle in the Park in Greenwich",
  "St Martin-in-the-Fields Church",
  "St Paul's Cathedral",
  "St. Martin's Theatre",
  "Storytelling with Santa at The Natural History Museum",
  "The Ice Rink at Westfield London",
  "The London Coliseum",
  "The Luna Cinema",
  "The Museum of the Home",
  "The Prince Charles Cinema",
  "The Santa Steam Express",
  "The Wimbledon Festive Light Trail",
  "The Winter Past",
  "Theatre Royal Haymarket",
  "Theatre Royal Stratford East",
  "Trafalgar Square",
  "Victorian Santa's grotto at the Museum of London Docklands",
  "Wands and Wizards of Exploratorium",
  "Westminster Abbey",
  "Wilton's Music Hall",
  "Winter Wonderland in Hyde Park"
]
category = "winter holidays"
winter_holidays.each do |activity|
  file_path = "db/files/#{activity}.json"
  if File.exists?(file_path)
    # TODO: Open the file and read its contents, add category
    file_contents = File.read(file_path)
    data = JSON.parse(file_contents)
    data['categories'] ||= [] # Ensure 'categories' key exists
    unless data['categories'].include?(category)
      data['categories'] << category
      puts "Added '#{category}' to the categories in #{activity}.json"
    end
    unless data['address']
      #make_api_call
      url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cplace_id"
      response = URI.open(url).read
      result = JSON.parse(response)
      if result["candidates"].length > 0
        address = result["candidates"][0]["formatted_address"]
        formatted_address = result["candidates"][0]["formatted_address"]
      end
      if address
        data['address'] = address
        p "Updating the address for #{activity}"
      else
        p "Unable to find an address for #{activity}"
      end
    end
    updated_contents = JSON.generate(data)
    File.open(file_path, 'w') { |file| file.write(updated_contents) }
  else
    # make an initial query to get the place_i
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cname%2Crating%2Cplace_id%2Copening_hours%2Cgeometry"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["candidates"].length > 0
      place_id = result["candidates"][0]["place_id"]
      formatted_address = result["candidates"][0]["formatted_address"]
      url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Creviews%2Cuser_ratings_total%2Ceditorial_summary%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cgeometry%2Cphoto&place_id=#{place_id}&key=#{api_key}"
      response = URI.open(url).read
      result = JSON.parse(response)
      result["place_id"] = place_id
      result["address"] = formatted_address
      result["categories"] = ["#{category}"]
      p result["result"]["name"]
      File.open("db/files/#{activity}.json", "wb") do |f|
        f << JSON.generate(result)
      end
    end
    #sleep to avoid spamming the API
    # sleep(0.1)
  end
end

playgrounds = [
  "Abbey Lane Open Space, Stratford",
  "Acton Park Playground, Acton",
  "Alexandra Park, South Hampstead",
  "Alf Barrett Playground, Bloomsbury",
  "All Mead Gardens, Kingsmead Estate, Hackney",
  "Anne Keane Playground, Dickens Square, Southwark",
  "Astey's Row Playground, Islington",
  "Avenue Road Play Area, Acton",
  "Barking Park Playground, Barking",
  "Bartlett Park, Poplar",
  "Battersea Park Playground, Battersea",
  "Battersea Power Station Playground, Battersea",
  "Belgravia House, Clapham Park Estate",
  "Biodiversity Playground, Stratford",
  "Bisterne Avenue Park, Walthamstow",
  "Bloomsbury Square, Holborn",
  "Bodley Way Play Area, Elephant & Castle",
  "Brokky's Crofte, Walthamstow",
  "Brunswick Park, Camberwell",
  "Canary Wharf",
  "Canons Leisure Centre playground, Mitcham",
  "Causton Street Playground, Pimlico",
  "Children's Garden, Kew",
  "Clapton Pond Play Area, Clapton",
  "Clapton Square Playground, Hackney",
  "Claremont Park, Brent Cross Town",
  "Colindale Park",
  "Coppermill Park, Walthamstow",
  "Coram's Fields, Bloomsbury",
  "Crabtree Fields, Fitzrovia",
  "Diana Memorial Playground, Kensington Gardens, Queensway",
  "Elephant Park, Elephant & Castle",
  "Eltham Palace Play Area, Eltham",
  "Embassy Gardens Play Area, Nine Elms",
  "Emslie Horniman's Pleasance Park Playground, North Kensington",
  "Felnex Park, Hackbridge",
  "Finsbury Park",
  "Fitzrovia Children's Playground",
  "Forrester Way Play Area, Stratford",
  "Gloucester Gate, Regent's Park",
  "Golden Lane Estate Play Space, Barbican",
  "Goose Green, East Dulwich",
  "Graham Street Park, Islington",
  "Greenwich Park Playground, Greenwich",
  "Grosvenor Playground, Pimlico",
  "Gunnersbury Park Museum Playground, Gunnersbury",
  "Hackney Downs Playground, Lower Clapton",
  "Haggerston Park Playground, Haggerston",
  "Henry Reynolds Park, Leytonstone",
  "Hobbledown Heath, Hounslow",
  "Holland Park Adventure Playground, Holland Park",
  "Hornsey Park at Clarendon, Turnpike Lane",
  "Horseferry Playground, Victoria Tower Gardens, Westminster",
  "Jack Cornwell Park playground, Leyton",
  "Jubilee Gardens Playground, Waterloo",
  "Kensington Memorial Park, Ladbroke Grove",
  "Kilburn Grange Adventurous Children's Playground, Kilburn",
  "Kilburn Park Road Play Area, Kilburn",
  "King Square Gardens, Clerkenwell",
  "Kinloch Gardens, Finsbury Park",
  "Kite Playground, Cator Park, Kidbrooke Village",
  "Leathermarket Gardens Playground, Bermondsey",
  "Leman Street, Aldgate East",
  "Leyton Jubilee Park, Leyton",
  "Leyton Square Playground, Peckham",
  "Mapesbury Dell play area, Cricklewood",
  "Marylebone Green Playground, Regent's Park",
  "Milner Square, Islington",
  "Northala Fields, Northolt",
  "Paddington Recreation Ground Playground, Maida Vale",
  "Paddington Street Gardens Playground, Marylebone",
  "Parsloes Memphis, Parsloes Park, Becontree, Dagenham",
  "Peckham Rye Park Playground",
  "RAF Museum Playground, Colindale",
  "Ravenscroft Park, Bethnal Green",
  "Salter's Hill Playground, Norwood Park, West Norwood",
  "Seward Street, Clerkenwell",
  "Shepherd's Bush Green Playground, Shepherd's Bush",
  "Shepherdess Walk Park, Hoxton",
  "Shoreditch Park Playground, Hoxton",
  "South Carriage Drive Playground, Hyde Park, Knightsbridge",
  "South Dock Park Marvellous Maze",
  "Spa Fields Park, Exmouth Market",
  "Springfield Park Playground, Upper Clapton",
  "Squeaky Clean at Charlton Park, Charlton",
  "St Giles Playground, Covent Garden",
  "St. John's Hoxton Garden Playground, Hoxton",
  "Stationers Park, Crouch End",
  "Stoke Newington Common, Stoke Newington",
  "Stonebridge Gardens, Haggerston",
  "Sunrise Close Play Area, East Village",
  "Tandy Place Play Area, Hackney Wick",
  "The Cove, National Maritime Museum, Greenwich",
  "The Flamboyance of Flamingos, Parsloes Park, Becontree, Dagenham",
  "The Magic Garden, Hampton Court Palace, East Molesey",
  "Tumbling Bay Playground, Queen Elizabeth Olympic Park, Stratford",
  "Vauxhall Park Playground, Vauxhall",
  "Victoria & Alexandra Playground, Victoria Park, Hackney",
  "Victoria Embankment Gardens, Westminster",
  "Victoria Road play area, Leytonstone",
  "Victory Park Playground, East Village",
  "Wembley Park Play Park, Wembley",
  "West Ham Park",
  "Whale's Landing, Harbord Square Park, Canary Wharf",
  "Wick Green Playground, Hackney Wick",
  "Wild Kingdom Playspace, Three Mills Island",
  "Wiltshire Close, Chelsea",
  "Woodberry Down Park, North Hackney",
  "Woodhouse Urban Park, Kilburn",
  "Woodland Play Area, Burgess Park, Camberwell",
  "Wormholt Park Playground, White City",
  "WWT London Wetland Centre Playground, Barnes",
  "Clissold Park Playground",
  "Highbury Fields Playground",
  "St Paul's Shrubbery",
  "Finsbury Park Playground",
  "Woodberry Down Park",
  "London Fields Playground"
]
category = "playgrounds"
playgrounds.each do |activity|
  file_path = "db/files/#{activity}.json"
  if File.exists?(file_path)
    p "#{file_path} already exists"
    # TODO: Open the file and read its contents, add category
    file_contents = File.read(file_path)
    data = JSON.parse(file_contents)
    data['categories'] ||= [] # Ensure 'categories' key exists
    unless data['categories'].include?(category)
      data['categories'] << category
      puts "Added '#{category}' to the categories in #{activity}.json"
    end
    unless data['address']
      #make_api_call
      url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cplace_id"
      response = URI.open(url).read
      result = JSON.parse(response)
      if result["candidates"].length > 0
        address = result["candidates"][0]["formatted_address"]
        formatted_address = result["candidates"][0]["formatted_address"]
      end
      if address
        data['address'] = address
        p "Updating the address for #{activity}"
      else
        p "Unable to find an address for #{activity}"
      end
    end
    updated_contents = JSON.generate(data)
    File.open(file_path, 'w') { |file| file.write(updated_contents) }
  else
    # make an initial query to get the place_i
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cname%2Crating%2Cplace_id%2Copening_hours%2Cgeometry"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["candidates"].length > 0
      place_id = result["candidates"][0]["place_id"]
      formatted_address = result["candidates"][0]["formatted_address"]
      url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Creviews%2Cuser_ratings_total%2Ceditorial_summary%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cgeometry%2Cphoto&place_id=#{place_id}&key=#{api_key}"
      response = URI.open(url).read
      result = JSON.parse(response)
      result["place_id"] = place_id
      result["address"] = formatted_address
      result["categories"] = ["#{category}"]
      p result["result"]["name"]
      File.open("db/files/#{activity}.json", "wb") do |f|
        f << JSON.generate(result)
      end
    end
    #sleep to avoid spamming the API
    # sleep(0.1)
  end
end

play_cafes = [
  "Macaroni Penguin, Woolwich",
  "Toconoco, Haggerston",
  "Bear + Wolf, Tufnell Park",
  "Dreamcatcher, Crystal Palace",
  "Maggie and Rose Cafe, Islington",
  "Apple Tree Play Cafe, Herne Hill",
  "Apple Tree Play Cafe, Peckham Rye",
  "Dreami Play Cafe",
  "Apple Tree Childrens Cafe",
  "Sandscape Kids Play and Cafe",
  "Apple Tree Childrens Cafe",
  "Come 'n' Play Cafe",
  "Rainbow Soft Play & Cafe",
  "KidzPlay Cafe",
  "Priscilla's Play Cafe",
  "Ollie Polly Play Cafe",
  "Cheeky Chops Play Cafe",
  "Soft Play Cafe",
  "A Little Me Time",
  "Tots In London (formerly known as Tots In Town)",
  "Ty's kids cafe",
  "The Play Cafe",
  "Rainbow Cafe",
  "Role2Play",
  "AvoCuddle Playroom",
  "Krazy Kidz Cafe Ltd"
]
category = "play cafes"
play_cafes.each do |activity|
  file_path = "db/files/#{activity}.json"
  if File.exists?(file_path)
    # TODO: Open the file and read its contents, add category
    file_contents = File.read(file_path)
    data = JSON.parse(file_contents)
    data['categories'] ||= [] # Ensure 'categories' key exists
    unless data['categories'].include?(category)
      data['categories'] << category
      puts "Added '#{category}' to the categories in #{activity}.json"
    end
    unless data['address']
      #make_api_call
      url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cplace_id"
      response = URI.open(url).read
      result = JSON.parse(response)
      if result["candidates"].length > 0
        address = result["candidates"][0]["formatted_address"]
        formatted_address = result["candidates"][0]["formatted_address"]
      end
      if address
        data['address'] = address
        p "Updating the address for #{activity}"
      else
        p "Unable to find an address for #{activity}"
      end
    end
    updated_contents = JSON.generate(data)
    File.open(file_path, 'w') { |file| file.write(updated_contents) }
  else
    # make an initial query to get the place_i
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cname%2Crating%2Cplace_id%2Copening_hours%2Cgeometry"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["candidates"].length > 0
      place_id = result["candidates"][0]["place_id"]
      formatted_address = result["candidates"][0]["formatted_address"]
      url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Creviews%2Cuser_ratings_total%2Ceditorial_summary%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cgeometry%2Cphoto&place_id=#{place_id}&key=#{api_key}"
      response = URI.open(url).read
      result = JSON.parse(response)
      result["place_id"] = place_id
      result["address"] = formatted_address
      result["categories"] = ["#{category}"]
      p result["result"]["name"]
      File.open("db/files/#{activity}.json", "wb") do |f|
        f << JSON.generate(result)
      end
    end
    #sleep to avoid spamming the API
    # sleep(0.1)
  end
end


leisure_centres = [
  "Archway Leisure Centre",
  "Atherton Leisure Centre",
  "Britannia Leisure Centre",
  "Cally Pool & Gym",
  "Camberwell Leisure Centre",
  "Clissold Leisure Centre",
  "Finsbury Leisure Centre",
  "Golden Lane Sport & Fitness",
  "Highbury Leisure Centre",
  "Ironmonger Row Baths",
  "John Orwell Sports Centre",
  "Kentish Town Sports Centre",
  "Kings Hall Leisure Centre",
  "Latchmere Leisure Centre",
  "Leytonstone Leisure Centre",
  "Mile End Park Leisure Centre and Stadium",
  "Mile End Park Leisure Centre and Stadium",
  "Oasis Sports Centre",
  "Pancras Square Leisure",
  "Poplar Baths Leisure Centre and Gym",
  "Queensbridge Sports and Community Centre",
  "Seven Islands Leisure Centre",
  "Seymour Leisure Centre",
  "Tiller Leisure Centre",
  "Vauxhall Leisure Centre",
  "Wavelengths Leisure Centre",
  "Whitechapel Sports Centre",
  "York Hall Leisure Centre"
]
category = "leisure centres"
leisure_centres.each do |activity|
  file_path = "db/files/#{activity}.json"
  if File.exists?(file_path)
    # TODO: Open the file and read its contents, add category
    file_contents = File.read(file_path)
    data = JSON.parse(file_contents)
    data['categories'] ||= [] # Ensure 'categories' key exists
    unless data['categories'].include?(category)
      data['categories'] << category
      puts "Added '#{category}' to the categories in #{activity}.json"
    end
    unless data['address']
      #make_api_call
      url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cplace_id"
      response = URI.open(url).read
      result = JSON.parse(response)
      if result["candidates"].length > 0
        address = result["candidates"][0]["formatted_address"]
        formatted_address = result["candidates"][0]["formatted_address"]
      end
      if address
        data['address'] = address
        p "Updating the address for #{activity}"
      else
        p "Unable to find an address for #{activity}"
      end
    end
    updated_contents = JSON.generate(data)
    File.open(file_path, 'w') { |file| file.write(updated_contents) }
  else
    # make an initial query to get the place_i
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cname%2Crating%2Cplace_id%2Copening_hours%2Cgeometry"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["candidates"].length > 0
      place_id = result["candidates"][0]["place_id"]
      formatted_address = result["candidates"][0]["formatted_address"]
      url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Creviews%2Cuser_ratings_total%2Ceditorial_summary%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cgeometry%2Cphoto&place_id=#{place_id}&key=#{api_key}"
      response = URI.open(url).read
      result = JSON.parse(response)
      result["place_id"] = place_id
      result["address"] = formatted_address
      result["categories"] = ["#{category}","sports"]
      p result["result"]["name"]
      File.open("db/files/#{activity}.json", "wb") do |f|
        f << JSON.generate(result)
      end
    end
    #sleep to avoid spamming the API
    # sleep(0.1)
  end
end


libraries = [
  "Alexandra Park Library",
  "Archway Library",
  "Artizan Street Library & Community Centre",
  "Askew Road library",
  "Avonmore library and neighbourhood centre",
  "Barbican Children's Library",
  "Bibliotheque Quentin Blake",
  "Blue Anchor Library",
  "Brandon Library",
  "Brompton Library",
  "Camberwell Library",
  "Camden Town Library",
  "Canada Water Library",
  "Cat and Mouse Library",
  "Charing Cross Library",
  "Chelsea Library",
  "Childs Hill Library",
  "Church Street Library",
  "Clapton Library",
  "COLAI Library",
  "Coombes Croft Library",
  "Dalston C.L.R James Library",
  "Dulwich Library",
  "Finsbury Library",
  "First Steps Learning Centre",
  "Fulham library",
  "Greenhill Library",
  "Grove Vale Library",
  "Hackney Central Library",
  "Hammersmith library",
  "Highgate Library Civic & Cultural Centre",
  "Holborn Library",
  "Homerton Library",
  "Hornsey Library",
  "Islington Central Library",
  "Islington Central Reference Library",
  "Islington Computer Skills Centre",
  "Islington North Library",
  "Islington South Library",
  "Islington West Library",
  "John Harvard Library",
  "Keats Community Library",
  "Kensal Library",
  "Kensington Central Library",
  "Kentish Town Library",
  "Kingswood Library",
  "Lewis Carroll Children's Library",
  "Little Venice Sports Centre Library",
  "Lou's Little Library",
  "Maida Vale Library",
  "Marcus Garvey Library",
  "Marylebone Library",
  "Mayfair Library",
  "Mildmay Library",
  "Mother & Baby Picture Library",
  "Muswell Hill Library",
  "N4 Library",
  "North Kensington Library",
  "Notting Hill Gate Library",
  "Nunhead Library",
  "Paddington Children's Library",
  "Palmers Green Library",
  "Peckham Library",
  "Pickatale AS",
  "Pimlico Library",
  "Pinner Library",
  "Queen's Crescent Library",
  "Queen's Park Library",
  "Roxeth Library",
  "Shepherds Bush library",
  "Shoe Lane Library",
  "Shoreditch Library",
  "Southwark Heritage Centre and Walworth Library",
  "St Ann's Library",
  "St John's Wood Library",
  "Stamford Hill Library",
  "Stanmore Library",
  "Stoke Newington Library",
  "Stroud Green and Harringay Library",
  "Swiss Cottage Library",
  "Una Marson Library",
  "Victoria Library",
  "Westminster Music Library",
  "Wood Green Library",
  "Woodberry Down Library",
  "Woolwich Centre Library"
]
category = "libraries"
libraries.each do |activity|
  file_path = "db/files/#{activity}.json"
  if File.exists?(file_path)
    # TODO: Open the file and read its contents, add category
    file_contents = File.read(file_path)
    data = JSON.parse(file_contents)
    data['categories'] ||= [] # Ensure 'categories' key exists
    unless data['categories'].include?(category)
      data['categories'] << category
      puts "Added '#{category}' to the categories in #{activity}.json"
    end
    unless data['address']
      #make_api_call
      url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cplace_id"
      response = URI.open(url).read
      result = JSON.parse(response)
      if result["candidates"].length > 0
        address = result["candidates"][0]["formatted_address"]
        formatted_address = result["candidates"][0]["formatted_address"]
      end
      if address
        data['address'] = address
        p "Updating the address for #{activity}"
      else
        p "Unable to find an address for #{activity}"
      end
    end
    updated_contents = JSON.generate(data)
    File.open(file_path, 'w') { |file| file.write(updated_contents) }
  else
    # make an initial query to get the place_i
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cname%2Crating%2Cplace_id%2Copening_hours%2Cgeometry"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["candidates"].length > 0
      place_id = result["candidates"][0]["place_id"]
      formatted_address = result["candidates"][0]["formatted_address"]
      url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Creviews%2Cuser_ratings_total%2Ceditorial_summary%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cgeometry%2Cphoto&place_id=#{place_id}&key=#{api_key}"
      response = URI.open(url).read
      result = JSON.parse(response)
      result["place_id"] = place_id
      result["address"] = formatted_address
      result["categories"] = ["#{category}"]
      p result["result"]["name"]
      File.open("db/files/#{activity}.json", "wb") do |f|
        f << JSON.generate(result)
      end
    end
    #sleep to avoid spamming the API
    # sleep(0.1)
  end
end

soft_play = [
  "A Little Me Time, Ealing",
  "All Aboard at the London Transport Museum, Covent Garden",
  "Apple Tree Children's Cafe, Brixton",
  "Apple Tree Children's Cafe, Herne Hill",
  "Apple Tree Children's Cafe, Peckham Rye",
  "Baby Gym at Talacre Leisure Centre, Kentish Town",
  "Babylon Park, Camden Town",
  "Barnet Burnt Oak Leisure Centre",
  "Barnet Copthall Leisure Centre",
  "Bear & Wolf, Tufnell Park",
  "Bellingham Leisure & Lifestyle Centre",
  "Bertie & Boo's Adventure Island, Balham",
  "Britannia Leisure Centre, Hoxton",
  "Cheeky Chops, Twickenham",
  "Clissold Leisure Centre, Stoke Newington",
  "Cloud Twelve, Notting Hill",
  "Clown Town, North Finchley",
  "Curiouser, Hampstead",
  "Ding Dong Fun Bus, Tottenham",
  "Discover Children's Story Centre, Stratford",
  "Discovery Planet, Surrey Quays",
  "Dreami, Cambridge Heath",
  "East London Gymnastics Centre",
  "Edmonton Leisure Centre",
  "Finsbury Leisure Centre",
  "Flip Out Brent Cross",
  "Gambado, Fulham",
  "Gambado, Imperial Wharf",
  "GetSetGo, Putney",
  "Gymboree Play & Music East Dulwich",
  "Gymboree Play & Music Putney",
  "Gymboree Play & Music, Kensington",
  "Gymboree, Hampstead",
  "Hamley's, Westfield White City",
  "Hobbledown Heath, Hounslow",
  "Hullabaloo at the Sheriff Centre, West Hampstead",
  "Inflatanation, Colindale",
  "Jaego's House, Kensal Rise (members only)",
  "Jungle Monkeyz, Pinner",
  "Kensington Leisure Centre",
  "Kidspace, Croydon",
  "Kidspace, Romford",
  "Kidz Adventure Play Zone, Wood Green",
  "Kidz1, Ealing",
  "Kidzania, Westfield Mall",
  "Kidzmania, Clapton",
  "Kidzmania, Hackney",
  "Kindhaus, Stoke Newington",
  "King's Cross Station Family Waiting Room, King's Cross",
  "Kings Hall Leisure Centre",
  "Leytonstone Leisure Centre",
  "Little Bear, Tufnell Park",
  "Little Dinosaurs, Alexandra Park",
  "Little Giggles Stay & Play, Putney",
  "London Bridge Station play area",
  "Macaroni Penguin, Royal Docks",
  "Maggie & Rose Chiswick",
  "Maggie & Rose Kensington",
  "Maggie & Rose, Angel",
  "Maida Vale Soft Play",
  "Mel's Soft Play, Maida Vale",
  "Mile End Park Leisure Centre and Stadium",
  "Mudlarks, Museum of London Docklands, Canary Wharf",
  "Museum of the Home, Hoxton",
  "N20 Kids Club, North Finchley",
  "National Maritime Museum, Greenwich",
  "Old Bank Coffee House, East Barnet",
  "PACE, Camden, Various Locations",
  "Peace + Riot, West Dulwich",
  "Peckham Levels, Peckham",
  "Peter May Sports Centre",
  "Picnic, Kingston",
  "Play Base, National Army Museum, Chelsea",
  "Playworld, Westfield Stratford City, Stratford",
  "Polka, Wimbledon",
  "Poppets Stores, Islington",
  "Purple Dragon, Chelsea",
  "Queensbridge Sports and Community Centre",
  "Rainbow Creative Learning Centre, New Southgate",
  "Rainbow Soft Play & Cafe, Cockfosters",
  "Raphi & Flo, Winchmore Hill",
  "Red Stairs Soft Play, High Barnet",
  "Riverside Soft Play",
  "Role2Play, Walthamstow",
  "Sammy's Soft Play, Yogaloft, Queen's Park",
  "Sebright Children's Centre Stop & Play, Hackney",
  "Snakes & Ladders, Brentford",
  "Sobell Leisure Centre",
  "Sorted!, The Postal Museum, Farringdon",
  "Southgate Leisure Centre",
  "Squish Space, Barbican",
  "Substation, South London",
  "Sutcliffe Park Sports Centre",
  "Swiss Cottage Leisure Centre",
  "Talacre Community Sports Centre",
  "The Can Club, Forest Gate",
  "The Garden at the Science Museum, Kensington",
  "The Markfield Project, Tottenham",
  "The Mill E17, Walthamstow",
  "The Moustache, Sydenham",
  "The RAF Museum, Colindale",
  "The Sherriff Centre, West Hampstead",
  "Tiller Leisure Centre Rascals Play Area, Isle of Dogs",
  "Tiny Tigers, South Quay",
  "Toconoco, Haggerston",
  "Topsy Turvy World, Brent Cross",
  "Tots in London, Deptford",
  "Totstars - Toby's Adventure Club, Streatham",
  "Treetops Soft Play at Talacre Community Sports Centre, Camden",
  "Under1Roof, Woolwich",
  "Waltham Forest Feel Good Centre Soft Play, Walthamstow",
  "Wavelengths Leisure Centre Soft Play, Deptford",
  "Yellow Warbler, Stoke Newington",
  "Yellow Warbler, Walthamstow",
  "Yonder, Walthamstow",
  "ZAPspace, Stratford"
]
category = "soft play"
soft_play.each do |activity|
  file_path = "db/files/#{activity}.json"
  if File.exists?(file_path)
    # TODO: Open the file and read its contents, add category
    file_contents = File.read(file_path)
    data = JSON.parse(file_contents)
    data['categories'] ||= [] # Ensure 'categories' key exists
    unless data['categories'].include?(category)
      data['categories'] << category
      puts "Added '#{category}' to the categories in #{activity}.json"
    end
    unless data['address']
      #make_api_call
      url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cplace_id"
      response = URI.open(url).read
      result = JSON.parse(response)
      if result["candidates"].length > 0
        address = result["candidates"][0]["formatted_address"]
        formatted_address = result["candidates"][0]["formatted_address"]
      end
      if address
        data['address'] = address
        p "Updating the address for #{activity}"
      else
        p "Unable to find an address for #{activity}"
      end
    end
    updated_contents = JSON.generate(data)
    File.open(file_path, 'w') { |file| file.write(updated_contents) }
  else
    # make an initial query to get the place_i
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cname%2Crating%2Cplace_id%2Copening_hours%2Cgeometry"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["candidates"].length > 0
      place_id = result["candidates"][0]["place_id"]
      formatted_address = result["candidates"][0]["formatted_address"]
      url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Creviews%2Cuser_ratings_total%2Ceditorial_summary%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cgeometry%2Cphoto&place_id=#{place_id}&key=#{api_key}"
      response = URI.open(url).read
      result = JSON.parse(response)
      result["place_id"] = place_id
      result["address"] = formatted_address
      result["categories"] = ["#{category}"]
      p result["result"]["name"]
      File.open("db/files/#{activity}.json", "wb") do |f|
        f << JSON.generate(result)
      end
    end
    #sleep to avoid spamming the API
    # sleep(0.1)
  end
end

swimming = [
  "Oasis Sports Centre",
  "Vauxhall Leisure Centre",
  "Pancras Square Leisure",
  "Ironmonger Row Baths",
  "Cally Pool & Gym",
  "Chelsea Sports Centre",
  "Britannia Leisure Centre",
  "Kentish Town Sports Centre",
  "Highbury Leisure Centre",
  "Swiss Cottage Leisure Centre",
  "Beacon High School",
  "York Hall Leisure Centre",
  "Kensington Leisure Centre",
  "Clissold Leisure Centre",
  "Archway Leisure Centre",
  "Mile End Park Leisure Centre and Stadium",
  "Kings Hall Leisure Centre",
  "Tiller Leisure Centre",
  "Phoenix Fitness Centre and Janet Adegoke Swimming Pool",
  "Wavelengths Leisure Centre",
  "London Fields Lido"
]
category = "swimming"
swimming.each do |activity|
  file_path = "db/files/#{activity}.json"
  if File.exists?(file_path)
    # TODO: Open the file and read its contents, add category
    file_contents = File.read(file_path)
    data = JSON.parse(file_contents)
    data['categories'] ||= [] # Ensure 'categories' key exists
    unless data['categories'].include?(category)
      data['categories'] << category
      puts "Added '#{category}' to the categories in #{activity}.json"
    end
    unless data['address']
      #make_api_call
      url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cplace_id"
      response = URI.open(url).read
      result = JSON.parse(response)
      if result["candidates"].length > 0
        address = result["candidates"][0]["formatted_address"]
        formatted_address = result["candidates"][0]["formatted_address"]
      end
      if address
        data['address'] = address
        p "Updating the address for #{activity}"
      else
        p "Unable to find an address for #{activity}"
      end
    end
    updated_contents = JSON.generate(data)
    File.open(file_path, 'w') { |file| file.write(updated_contents) }
  else
    # make an initial query to get the place_i
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cname%2Crating%2Cplace_id%2Copening_hours%2Cgeometry"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["candidates"].length > 0
      place_id = result["candidates"][0]["place_id"]
      formatted_address = result["candidates"][0]["formatted_address"]
      url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Creviews%2Cuser_ratings_total%2Ceditorial_summary%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cgeometry%2Cphoto&place_id=#{place_id}&key=#{api_key}"
      response = URI.open(url).read
      result = JSON.parse(response)
      result["place_id"] = place_id
      result["address"] = formatted_address
      result["categories"] = ["#{category}"]
      p result["result"]["name"]
      File.open("db/files/#{activity}.json", "wb") do |f|
        f << JSON.generate(result)
      end
    end
    #sleep to avoid spamming the API
    # sleep(0.1)
  end
end


adventure_playgrounds = [
  "3 Corners Adventure Playground",
  "Acacia Adventure Playground",
  "Adventure Play Hub",
  "Attlee Centre Adventure Playground",
  "Barnard Adventure Playground",
  "Bethwin Road Adventure Playground",
  "Bolton Crescent Adventure Playground",
  "CAPE Adventure Playground",
  "Chelsea Adventure Playground",
  "Coldharbour Adventure Playground",
  "Cornwallis Adventure Playground",
  "Crumbles Castle Adventure Playground",
  "Dexter Road Adventure Playground",
  "Dog Kennel Hill Adventure Playground",
  "Dumps Adventure Playground",
  "ELHAP Adventure Playground",
  "Ellen Brown Adventure Playground",
  "Evergreen Adventure Playground",
  "Flashpoint Adventure Playground",
  "Frederick's Adventure Playground",
  "Glamis Adventure Playground",
  "Glyn Hopkin Abbey Hub",
  "Glyndon Adventure Playground",
  "Grove Adventure Playground",
  "Grow Wild Adventure Playground",
  "Hackney Marsh Adventure Playground",
  "Hampstead Heath Adventure Playground and Clubhouse",
  "Hayward Adventure Playground",
  "Home Park Adventure Playground",
  "Homerton Grove Adventure Playground",
  "Honor Oak Adventure Playground",
  "Hornimans Adventure Playground",
  "Kennington Park Adventure Playground",
  "KIDS Adventure Playground Hackney",
  "King Henry's Walk Adventure Playground",
  "Lady Allen Adventure Playground",
  "Ladywell Fields Adventure Playground",
  "Little Wormwood Scrubs Adventure Playground",
  "Living Space Adventure Playground",
  "Lollard Street Adventure Playground",
  "Lumpy Hill Adventure Playground",
  "Marble Hill Adventure Playground",
  "Markfield Adventure Playground",
  "Martin Luther King Adventure Playground",
  "Max Roach Adventure Playground",
  "Meridian Adventure Play Centre",
  "Mint Street Adventure Playground",
  "Notting Hill Adventure Playground",
  "Oasisplay Adventure Playground",
  "Oasisplay Nature Garden",
  "Pearson Street Adventure Playground",
  "Peckham Rye Adventure Playground",
  "Plumstead Common Adventure Play Centre",
  "Richard MacVicar Adventure Playground",
  "Roman Road Adventure Playground",
  "Shakespeare Walk Adventure Playground",
  "Shoreditch Adventure Playground",
  "Slade Gardens Adventure Playground",
  "Somerford Grove Adventure Playground",
  "Somerville Adventure Playground",
  "Stewart's Road Adventure Playground",
  "Streatham Vale Adventure Playground",
  "Terence Brown Arc in the Park",
  "The Log Cabin Adventure Playground",
  "Three Acres Adventure Playground",
  "Three Corners Adventure Playground",
  "Timbuktu Adventure Playground",
  "Toffee Park Adventure Playground",
  "Triangle Adventure Playground",
  "Tulse Hill Adventure Playground",
  "Waterside Adventure Playground",
  "Weavers Adventure Playground",
  "White City Adventure Playground",
  "Whitehorse Adventure Playground",
  "Willington Road Adventure Playground",
  "Wiltshire Close Adventure Playground",
  "Woolwich Adventure Playground"
]
category = "adventure playgrounds"
adventure_playgrounds.each do |activity|
  file_path = "db/files/#{activity}.json"
  if File.exists?(file_path)
    # TODO: Open the file and read its contents, add category
    file_contents = File.read(file_path)
    data = JSON.parse(file_contents)
    data['categories'] ||= [] # Ensure 'categories' key exists
    unless data['categories'].include?(category)
      data['categories'] << category
      puts "Added '#{category}' to the categories in #{activity}.json"
    end
    unless data['address']
      #make_api_call
      url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cplace_id"
      response = URI.open(url).read
      result = JSON.parse(response)
      if result["candidates"].length > 0
        address = result["candidates"][0]["formatted_address"]
        formatted_address = result["candidates"][0]["formatted_address"]
      end
      if address
        data['address'] = address
        p "Updating the address for #{activity}"
      else
        p "Unable to find an address for #{activity}"
      end
    end
    updated_contents = JSON.generate(data)
    File.open(file_path, 'w') { |file| file.write(updated_contents) }
  else
    # make an initial query to get the place_i
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cname%2Crating%2Cplace_id%2Copening_hours%2Cgeometry"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["candidates"].length > 0
      place_id = result["candidates"][0]["place_id"]
      formatted_address = result["candidates"][0]["formatted_address"]
      url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Creviews%2Cuser_ratings_total%2Ceditorial_summary%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cgeometry%2Cphoto&place_id=#{place_id}&key=#{api_key}"
      response = URI.open(url).read
      result = JSON.parse(response)
      result["place_id"] = place_id
      result["address"] = formatted_address
      result["categories"] = ["#{category}"]
      p result["result"]["name"]
      File.open("db/files/#{activity}.json", "wb") do |f|
        f << JSON.generate(result)
      end
    end
    #sleep to avoid spamming the API
    # sleep(0.1)
  end
end


water_play = [
  "Granary Square Fountains, King's Cross",
  "Lewis Cubitt Square Fountains, King's Cross",
  "Rosemary Gardens water play, Islington",
  "Highbury Fields water play, Islington",
  "Priory Park paddling pool, Hornsey",
  "Lordship Recreation Ground paddling pool, Tottenham",
  "Bruce Castle Park paddling pool, Tottenham",
  "Whittington Park water play, Archway",
  "Barnard Park water play, Islington",
  "Animal Adventure water play at ZSL London Zoo, Camden Town",
  "King Square Gardens splash pad, Islington",
  "Gloucester Gate Playground water play, Regent's Park, Camden Town",
  "Parliament Hill Paddling Pool, Hampstead Heath, Hampstead",
  "Queen's Park Padding Pool, Queen's Park",
  "Union Park play fountain, Wembley",
  "Arena Square, Wembley Park",
  "Finsbury Park splash play, Finsbury Park",
  "Elthorne Park Playground water play, Hornsey",
  "Swiss Cottage Open Space splash pad, Swiss Cottage",
  "Kilburn Grange Park splash pad, Kilburn",
  "Paradise Park splash pad, Islington",
  "Barking Splash Park, Barking",
  "Victoria Park Splash Pool, Hackney",
  "Tumbling Bay water play & Waterworks Fountains, Queen Elizabeth Olympic Park, Stratford",
  "Gauging Square fountains, Wapping",
  "Goodman's Field fountains, Aldgate",
  "The Children's Play Pavilion & Park splash pad, Mile End Park",
  "St John at Hackney Churchyard Gardens fountains, Hackney Central",
  "Britannia Leisure Centre pool splash pad (indoor), Hoxton",
  "Leyton Leisure Centre pool splash pad (indoor), Leyton",
  "Clissold Park splash pad, Stoke Newington",
  "London Fields paddling pool, Hackney ",
  "Aldgate Square fountains, Aldgate",
  "Fellowship Square fountains, Walthamstow",
  "Stubbers Adventure Centre paddling pool, Upminster",
  "Stratford Park padding pool",
  "Broadgate Exchange Play Fountains, Liverpool Street",
  "St. Mary's Churchyard Park fountains, Elephant & Castle",
  "Elephant Springs water play, Elephant Park, Elephant & Castle",
  "Wimbledon Sprinkler Park, Wimbledon",
  "Sir Joseph Hood Playing Fields paddling pool, Motspur Park",
  "Kingston Market Square fountains, Kingston",
  "Danson Splash Park, Bexleyheath",
  "Southwark Park splash pad, Bermondsey",
  "Brockwell Park wet play, Lambeth",
  "Myatt's Fields splash pad, Camberwell",
  "Norwood Park water play, Gipsy Hill",
  "Royal Arsenal Riverside fountains, Woolwich",
  "Ruskin Park paddling pool, Denmark Hill",
  "Rookery Paddling Pool, Streatham Common",
  "Clapham Common paddling pool, Clapham",
  "North Sheen Recreation Ground paddling pool, Richmond",
  "Vine Road Recreation Ground paddling pool, Barnes",
  "Wells Park water play, Sydenham",
  "Greenwich Park Playground water play, Greenwich",
  "Peckham Rye Park water play, Peckham",
  "Beddington Park water play, Sutton",
  "Croydon Road Recreation Ground paddling pool, Beckenham",
  "Magic Garden water play, Hampton Court Palace",
  "London Bridge Pier fountain",
  "Fountain Park Way fountains, Westfield, Wood Lane",
  "Diana Princess of Wales Memorial Fountain, Hyde Park",
  "John Madejski Garden paddling pool & fountains, V&A, South Kensington",
  "Kensington Memorial Park Water Play Area, Ladbroke Grove",
  "Duke of York Square fountains, Chelsea",
  "Duke's Meadows paddling pool, Chiswick",
  "Merchant Square fountains, Paddington Basin",
  "Design Museum fountains, Kensington",
  "London Wetland Centre water-play area, Barnes",
  "Castlenau Recreation Ground paddling pool, Barnes",
  "Bishop's Park water play, Putney",
  "Kew Gardens Children's Garden, Kew",
  "Ruislip Lido splash pad, Ruislip",
  "Ravenscourt Park paddling pool, Hammersmith",
  "Palewell Common & Fields paddling pool, East Sheen",
  "Edmond J Safra Fountain Court at Somerset House",
  "Russell Square Gardens fountain, Bloomsbury",
  "Coram's Fields paddling pool Bloomsbury",
  "Causton Street Playground water play, Pimlico",
  "Leicester Square fountains, West End",
  "Marylebone Green Playground water play, Regents Park, Marylebone",
  "More London Riverside Fountains, London Bridge",
  "Jeppe Hein's Appearing Rooms, Southbank Centre, Waterloo",
  "Swanley Park water park, Swanley, Kent",
  "The Harlow Splash Park, Harlow, Essex",
  "Walmer Paddling Pool, Walmer, Kent",
  "Stanborough Park Splashlands, Welwyn Garden City, Hertfordshire",
  "Splash 'n' Play, Willen Lake, Milton Keynes",
  "Lakeside Shopping Centre fountains, Grays, Essex",
  "The Strand Leisure Park, Gillingham, Kent",
  "Bancroft Recreation Ground splash park, Hitchin, Hertfordshire",
  "Howard Park splash park, Letchworth, Hertfordshire",
  "Royston Splash Park, Royston, Hertfordshire",
  "Stoke Park paddling pool, Guildford",
  "Cassiobury Park splash pools, Watford, Hertfordshire",
  "Willen Lake splash park, Milton Keynes, Buckinghamshire",
  "Verulamium Splash Park, St. Alban's",
  "King George Recreation Ground splash park, Bushey"
]
category = "water play"
water_play.each do |activity|
  file_path = "db/files/#{activity}.json"
  if File.exists?(file_path)
    # TODO: Open the file and read its contents, add category
    file_contents = File.read(file_path)
    data = JSON.parse(file_contents)
    data['categories'] ||= [] # Ensure 'categories' key exists
    unless data['categories'].include?(category)
      data['categories'] << category
      puts "Added '#{category}' to the categories in #{activity}.json"
    end
    unless data['address']
      #make_api_call
      url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cplace_id"
      response = URI.open(url).read
      result = JSON.parse(response)
      if result["candidates"].length > 0
        address = result["candidates"][0]["formatted_address"]
        formatted_address = result["candidates"][0]["formatted_address"]
      end
      if address
        data['address'] = address
        p "Updating the address for #{activity}"
      else
        p "Unable to find an address for #{activity}"
      end
    end
    updated_contents = JSON.generate(data)
    File.open(file_path, 'w') { |file| file.write(updated_contents) }
  else
    # make an initial query to get the place_i
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cname%2Crating%2Cplace_id%2Copening_hours%2Cgeometry"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["candidates"].length > 0
      place_id = result["candidates"][0]["place_id"]
      formatted_address = result["candidates"][0]["formatted_address"]
      url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Creviews%2Cuser_ratings_total%2Ceditorial_summary%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cgeometry%2Cphoto&place_id=#{place_id}&key=#{api_key}"
      response = URI.open(url).read
      result = JSON.parse(response)
      result["place_id"] = place_id
      result["address"] = formatted_address
      result["categories"] = ["#{category}"]
      p result["result"]["name"]
      File.open("db/files/#{activity}.json", "wb") do |f|
        f << JSON.generate(result)
      end
    end
    #sleep to avoid spamming the API
    # sleep(0.1)
  end
end


forest_school = [
  "Broadwaters' Children's Centre",
  "Clapton Park Children's Centre",
  "Woodlands Park Nursery School & Children's Centre",
  "Kay Rowe Nursery School and Children's Centre",
  "South Acton Children's Centre",
  "Rebecca Cheetham Nursery & Children's Centre",
  "Waterways Children's Centre",
  "Maytree Nursery School and Children's Centre",
  "Rachel McMillan Nursery School and Children's Centre",
  "Pembury House Nursery School and Children's Centre",
  "Hampden Way Nursery School and Children's Centre",
  "Effra Nursery School and Children's Centre",
  "Sheringham Nursery School and Children's Centre",
  "Rowland Hill Nursery School and Children's Centre",
  "Greenfields Nursery School and Children's Centre",
  "St Margaret's Nursery School and Children's Centre",
  "Crosfield Nursery School and Children's Centre",
  "Oliver Thomas Nursery School and Children's Centre"
]
category = "forest school"
forest_school.each do |activity|
  file_path = "db/files/#{activity}.json"
  if File.exists?(file_path)
    # TODO: Open the file and read its contents, add category
    file_contents = File.read(file_path)
    data = JSON.parse(file_contents)
    data['categories'] ||= [] # Ensure 'categories' key exists
    unless data['categories'].include?(category)
      data['categories'] << category
      puts "Added '#{category}' to the categories in #{activity}.json"
    end
    unless data['address']
      #make_api_call
      url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cplace_id"
      response = URI.open(url).read
      result = JSON.parse(response)
      if result["candidates"].length > 0
        address = result["candidates"][0]["formatted_address"]
        formatted_address = result["candidates"][0]["formatted_address"]
      end
      if address
        data['address'] = address
        p "Updating the address for #{activity}"
      else
        p "Unable to find an address for #{activity}"
      end
    end
    updated_contents = JSON.generate(data)
    File.open(file_path, 'w') { |file| file.write(updated_contents) }
  else
    # make an initial query to get the place_i
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{activity}&inputtype=textquery&key=#{api_key}&fields=formatted_address%2Cname%2Crating%2Cplace_id%2Copening_hours%2Cgeometry"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["candidates"].length > 0
      place_id = result["candidates"][0]["place_id"]
      formatted_address = result["candidates"][0]["formatted_address"]
      url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Creviews%2Cuser_ratings_total%2Ceditorial_summary%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cgeometry%2Cphoto&place_id=#{place_id}&key=#{api_key}"
      response = URI.open(url).read
      result = JSON.parse(response)
      result["place_id"] = place_id
      result["address"] = formatted_address
      result["categories"] = ["#{category}"]
      p result["result"]["name"]
      File.open("db/files/#{activity}.json", "wb") do |f|
        f << JSON.generate(result)
      end
    end
    #sleep to avoid spamming the API
    # sleep(0.1)
  end
end

puts "Finished adding files."
