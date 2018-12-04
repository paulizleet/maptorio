require 'json'
class BuildgraphsJob < ApplicationJob
  queue_as :default

  def perform(*args)

      @ms = Modsuite.all
      @ms.each do |s|
        next if s == "built"
        i = 0
        s.graph
        f = File.new("vendor/construction/graphs/#{s.name}.json", "w")
        mongojs = s.as_json
        realjs = JSON.pretty_generate(mongojs)
        f.write(realjs)
        f.close
        s.save
      end
      p "Initial graphs created"

      #run Node in shell
      `node vendor/construction/buildgraphs.js`
      p "Graphs built"

      @ms.each do |s|
        f = open("public/graphs/graph_#{s.name}.json")
        s.graph = f.read
        s.save
        f.close
      end

      puts "graphs saved to db"

      

    p "Builds are all good"
  end
end
