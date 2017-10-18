#edad_meses = 2*12
#peso = 16
#talla = 50
#sexo = 'F'
#creatinina = 1.3

require 'rubygems'  
require 'sinatra'

configure do
 set :public_folder, Proc.new { File.join(root, "static") }
 # set :public_folder, File.dirname(publico) + '/static'
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
  
  if sexo=="F"
    f="checked"
    m=0
  else
    m="checked"
    f=0
  end
  
  edad=edad_anos*12+edad_meses 
  gfr, equation = calculate_gfr(edad,sexo,peso,talla,creatinina)
  gfrn, equationn = calculate_gfr_nuevo(edad,sexo,talla,creatinina)
  erb:resultstfg, :locals => {:tfg => gfr, :equation=> equation, :tfgn =>gfrn, :equationn=> equationn, :edad=>edad,:peso=>peso,:anios=>edad_anos,:meses=>edad_meses,:female=>f,:male=>m,:talla=>talla,:creatinina=>creatinina}
end

get '/tfgn' do  
    erb:tfg 
end
post '/tfgn' do
  peso=params[:peso].to_i
  edad_anos=params[:anios].to_i 
  edad_meses=params[:meses].to_i 
  sexo=params[:sexo]
  talla=params[:talla].to_i
  creatinina=params[:creatinina].to_f
  
  edad=edad_anos*12+edad_meses 
  
  tfg_nuevo = sprintf "%.1f", calculate_gfr_nuevo(edad,sexo,talla,creatinina)
  erb:resultstfg, :locals => {:tfg => tfg,:edad=>edad,:mese=>edad_meses}
end

get '/fmru' do  
    erb:fmru
    
end
     
  post '/fmru' do  
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
    
    erb:resultsfmru, :locals => {:edad => edad, :peso => peso, :hydration => hydration,:size =>size,:flow =>flow,:gadolinio =>gadolinio,:flowga =>flowga, :volume =>volume, :dosis =>dosis}
 end  

def bedside_schwartz(talla, creatinina) # Para niños, la mas moderna y recomendada por la ACR
	#gfr=
  talla*0.41 / creatinina
  #equation='bedside Schwartz'
  #output=[gfr, equation]
end

def schwartz(sexo, edad_meses, talla, creatinina) # La antigua pediatrica
	k = case edad_meses
			when 0..3 then 0.33
			when 4..12 then 0.45
			when 13..144 then 0.55
			when 145..252
				if sexo == 'F'
					0.55
				else
					0.7
				end
			else
				puts "Hubo un error al calcular la TGF con la formula de Schwartz"
			end
	#gfr=
  talla*k / creatinina
  #equation='Schwartz'
  #output=[gfr, equation]
end

def cockroft(sexo, edad, peso, creatinina) # La antigua de adultos
	if sexo == 'F'
		k=0.85
	else
		k=1
	end
	#gfr=
  (((140-edad)*peso)*k/(72*creatinina))
  #equation='Cockroft'
  #output=[gfr, equation]
end

def mdrd(edad_meses,sexo,creatinina) # La nueva de adultos recomendada por la NKF (mayores de 18)
	edad = edad_meses/12
	if sexo == 'F'
		k=0.742
	else
		k=1
	end
	mdr=creatinina**-1.154
      mdr=mdr*edad** -0.203
	#gfr=
  175*mdr*k
  #equation= 'MDRD'
  #output=[gfr, equation]
end

def calculate_gfr(edad_meses,sexo,peso,talla,creatinina) # Con las formulas viejas que estamos usando
	edad = edad_meses/12

	if edad > 21
		puts "Usando la formula de Cockroft-Gault..."
		puts "Edad: #{edad}, Sexo: #{sexo}, Peso: #{peso}, Creatinina: #{creatinina}"
    gfr=cockroft(sexo, edad, peso, creatinina)
		equation = "Cockroft-Gault"
    return [gfr,equation]
	else
		puts "Usando la formula de Schwartz..."
		puts "Edad (en meses): #{edad_meses}, Sexo: #{sexo}, Talla: #{talla}, Creatinina: #{creatinina}"
    gfr=schwartz(sexo, edad_meses, talla, creatinina)
		equation = "Schwartz"
    return [gfr,equation]
	end
end

def calculate_gfr_nuevo(edad_meses,sexo,talla,creatinina) # Con las formulas nuevas, recomendadas por la ACR
	edad = edad_meses/12

	if edad > 18
		puts "Usando la formula de MDRD..."
		puts "Edad: #{edad}, Sexo: #{sexo}, Creatinina: #{creatinina}"
                equation="MDRD"
		gfr=mdrd(edad_meses,sexo,creatinina)
	else
		puts "Usando la formula de Bedside Schwartz..."
		puts "Talla: #{talla}, Creatinina: #{creatinina}"
		gfr=bedside_schwartz(talla, creatinina)
                equation="Bedside Schwartz"
	end
        return [gfr,equation]
end
