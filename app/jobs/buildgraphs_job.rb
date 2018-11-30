require 'json'
class BuildgraphsJob < ApplicationJob
  queue_as :default

  def perform(*args)

      @ms = Modsuite.all
      @ms.each do |s|
        i = 0
            s.graph
            f = File.new("misc/graphs/#{s.name}.json", "w")
            mongojs = s.as_json
            realjs = JSON.pretty_generate(mongojs)
            f.write(realjs)
            f.close
            s.save
      end

      #run Node in shell
      `node buildgraphs.js`

      @ms.each do |s|
        p s.name
        f = open("public/graphs/graph_#{s.name}.json")
        p f

        s.graph = f.read
        s.save
        f.close
      end

      


  end
end
