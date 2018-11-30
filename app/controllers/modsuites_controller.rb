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

    def graph
        if request.xhr?
            render plain: Modsuite.find(params[:id]).graph
        else
            nil
        end
    end
end
