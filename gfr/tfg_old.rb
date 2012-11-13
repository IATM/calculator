"Calculadora Tasa de filtrado glomerural"

require 'rubygems'  
require 'sinatra'

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
end

get '/tfg' do  
    erb:tfg
    
end
     
  post '/tfg' do  
    peso=params[:peso].to_i
    edad_anos=params[:anios].to_i
    edad_meses=params[:meses].to_i 
    sexo=params[:sexo]
    talla=params[:talla].to_i
    creatinina=params[:creatinina].to_f
    
    edad=edad_anos+edad_meses/12
    
    if sexo=="f"
      factorsexo=0.85
    else
      factorsexo=1
    end
      
   
    if edad > 21 
    
      tfg=(140-edad)*peso*factorsexo/(72*creatinina)
      primero=140-edad
      segundo=peso*(primero)
      tercero=segundo*factorsexo
      cuarto=72*creatinina
      quinto=tercero/cuarto
      cual=1
      
    else
      cual=2
      if edad<0.5
        k=0.33
      elsif edad< 1
        k=0.45
      elsif edad< 12
        k=0.55
      else
        if sexo=="F"
          k=0.55
        else
          k=0.65
        end
        
      end
      tfg= talla*k/creatinina 
    end

    erb:resultstfg, :locals => {:tfg => tfg,:cual=>cual, :edad =>edad, :creatinina=>creatinina,:primero=>primero,:segundo=>segundo,:tercero=>tercero,:cuarto=>cuarto,:quinto=>quinto,:sexo=>sexo,:factorsexo=>factorsexo}

    
   
    
  
 end  
   