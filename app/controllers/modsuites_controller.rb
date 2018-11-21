class ModsuitesController < ApplicationController
    
    def show
        @modsuite = Modsuite.find(params[:id])
        @title_addon = @modsuite.name

        render :show
    end


    def index
        @suites = Modsuite.all
        render :index
    end


    

end
