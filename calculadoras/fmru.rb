
require 'rubygems'  
require 'sinatra'

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
end

get '/form' do  
    erb:form
    
end
     
  post '/form' do  
    peso=params[:peso].to_i
    edad=params[:edad].to_i
    
   

    hydration=peso*20
    if hydration >1000
        hydration =1000
        end

   

    size=((edad/4)+4)*2
    
    

    dosis=peso

    if dosis >20
        dosis=20
    end
    flow=10

   
    gadolinio=0.2 * peso
    if gadolinio<2
    gadolinio=2
        end
    if gadolinio>20
    gadolinio=20
    end

    if peso<=27.5
    flowga=0.1
    elsif peso<=57.5
    flowga=0.15
    else
    flowga=0.2
    end

    volume=12
    
    erb:results, :locals => {:hydration => hydration,:size =>size,:flow =>flow,:gadolinio =>gadolinio,:flowga =>flowga, :volume =>volume, :dosis =>dosis}
    
  
 end  
   
   get '/secret' do
     erb:secret
     end
     
    post '/secret' do  
    params[:secret].reverse  
    end  
    
    get '/decrypt/:secret' do  
      params[:secret].reverse  
    end 
    
    
    not_found do  
      status 404  
      'not found'  
    end 