require 'open-uri'
require 'json'

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
  "London Museum of Water & Steam"
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
      api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
    api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
  "London Museum of Water & Steam"
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
      api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
    api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
  "Kew Gardens"
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
      api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
    api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
      api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
    api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
      api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
    api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
      api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
    api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
      api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
    api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
      api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
    api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
      api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
    api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
  "'Carnaby Universe'",
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
      api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
    api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
  "WWT London Wetland Centre Playground, Barnes"
]
category = "playgrounds"
playgrounds.each do |activity|
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
      api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
    api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
      api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
    api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
      api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
    api_key = 'AIzaSyCyXUFkhIMwi0K1UuiQdlHgspBSrMqpVrM'
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
