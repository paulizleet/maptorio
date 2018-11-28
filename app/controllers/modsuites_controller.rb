class ModsuitesController < ApplicationController
    
    def show
        @modsuite = Modsuite.find(params[:id])

        #@graph = 

        @title_addon = @modsuite.name

        render :show
    end


    def index
        @suites = Modsuite.all
        render :index
    end

    def graph
        p params
        p "pengis"

    end
end
