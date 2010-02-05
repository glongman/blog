require 'toto'

@config = Toto::Config::Defaults

task :default => :new

task :new do
  title = ENV['TITLE'] || 'Change Me'
  slug = title.downcase.gsub(/&/, 'and').gsub(/\s+/, '-').gsub(/[^a-z0-9-]/, '')
  article = {'title' => title, 'date' => Time.now.strftime("%d/%m/%Y"), 'author' => @config[:author]}.to_yaml
  article << "\n"
  article << "Once upon a time...\n\n"

  path = "#{Toto::Paths[:articles]}/#{Time.now.strftime("%Y-%m-%d")}-#{slug}.#{@config[:ext]}"

  unless File.exist? path
    File.open(path, "w") do |file|
      file.write article
    end
    toto "an article was created for you at #{path}."
  else
    toto "I can't create the article, #{path} already exists."
  end
end

task :publish do
  toto "publishing your article(s)..."
  `git push origin master`
end

def toto msg
  puts "\n  toto ~ #{msg}\n\n"
end

