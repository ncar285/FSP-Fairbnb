require "open-uri"

require 'aws-sdk-s3'

require 'csv'


#! SEED 30 LISTINGS

num_listings = 30;

puts "importing listings.csv..."
csv_text = File.read(Rails.root.join('db', 'listings.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
n = 1;
csv.each do |row|
  puts "filling data for listing ##{n}"
  listing = Listing.new
  listing.owner_id = row['owner_id'].to_i
  listing.title = row['title']
  listing.description = row['description']
  listing.price = row['price'].to_i
  listing.state = row['state']
  listing.city = row['city']
  listing.address = row['address']
  listing.postcode = row['postcode']
  listing.guests = row['guests'].to_i
  listing.bedrooms = row['bedrooms'].to_i
  listing.beds = row['beds'].to_i
  listing.baths = row['baths'].to_i
  listing.pets = row['pets'] == 'true'
  listing.tag_line = row['tag_line']
  listing.save!
  puts "listing ##{n} saved!"
  n += 1
  break if n==num_listings+1
end
puts "uploading listing's..."
photo_counts = [10, 6, 5, 8, 8, 7, 7, 6, 11, 
  11, 8, 9, 11, 7, 14, 11, 14, 12, 10, 15, 
  9, 13, 10, 9, 12, 9, 10, 13, 9, 12, 7]
puts "phhoto array lengths matches listing count: #{(num_listings == photo_counts)}"
listings = Listing.order(:id)
listings.each do |listing|
  n = listing.id
  puts "uploading listing's ##{n}'s photos..."
  base = "https://fairbnb-user-seeds.s3.us-west-1.amazonaws.com/house#{n}"
  photo_count = photo_counts[n-1]
  puts "photo count = #{photo_count}"
  (1..photo_count).each do |i|
    file = URI.open("#{base}/#{i}.jpg")
    puts "path: #{"#{base}/#{i}.jpg"}"
    listing.photos.attach(io: file, filename: "#{i}.jpg")
  end
  puts "listings' photos filled!"
end
