
Given (/the following movies exist:/) do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(title: movie[:title], rating: movie[:rating], release_date: movie[:release_date])
  end
end

Then (/(.*) seed movies should exist/) do | n_seeds |
  expect(Movie.count).to match (n_seeds.to_i)
end

Then (/I should see "(.*)" before "(.*)"/) do |e1, e2|
  expect(/[\s\S]*#{e1}[\s\S]*#{e2}/).to match(page.body)
end

When (/^I press "(.*)" button/) do |button|
  click_button button
end

When (/I (un)?check the following ratings: (.*)/) do |choice, rating_list|
  ratings = rating_list.split(', ')
  ratings.each do |rating|
    choice ? uncheck("ratings[#{rating}]") : (check("ratings[#{rating}]"))
  end
end

Then (/I should (not )?see the following movies: (.*)$/) do |presence, movie_list|
  movies = movie_list.split(', ')
  movies.each do |movie|
    presence.nil? ? (expect(page).to have_content(movie)) : (expect(page).not_to have_content(movie))
  end
end

Then (/I should see all the movies$/) do
  expect(page.all(:xpath, '//table[@id="movies"]//tbody//tr').count).to match(Movie.count)
end

Then ('table header {string} should be hilighted') do |string|
  className = 'hilite'
  elementId = nil
  if string == "Movie Title"
    elementId = 'title_header'
  end
  if string == "Release Date"
    elementId = 'release_date_header'
  end
  expect(page.find("##{elementId}").find(:xpath, '..')[:class].include?("#{className}")).to match(true)
end

Then (/I should see "(.*)" first/) do |movie_name|
  expect(page.first(:xpath, '//table[@id="movies"]//tbody//tr//td').text).to match(movie_name)
end

Then (/I should see "(.*)" last/) do |movie_name|
  expect(page.all(:xpath, '//table[@id="movies"]//tbody//tr').last.first('td').text).to match(movie_name)
end