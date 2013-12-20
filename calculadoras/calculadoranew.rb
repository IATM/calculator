#edad_meses = 2*12
#peso = 16
#talla = 50
#sexo = 'F'
#creatinina = 1.3

require 'rubygems'  
require 'sinatra'
require 'date'
require 'pony'

configure do
 set :public_folder, Proc.new { File.join(root, "static") }
 # set :public_folder, File.dirname(publico) + '/static'
end


get '/tfgn' do  
    erb:tfgn
    
end
post '/tfgn' do
  peso=params[:peso].to_i
  edad_anos=params[:anios].to_i 
  edad_meses=params[:meses].to_i 
  sexo=params[:sexo]
  talla=params[:talla].to_i
  creatinina=params[:creatinina].to_f
  afrod=params[:afrod].to_s
  d=Date.today
  date=d.to_s
  nombre=params[:nombre].split(' ').map {|w| w.capitalize }.join(' ')
  id=params[:id].to_str
  mostrar="2"
  ip=request.ip
  
  if sexo=="F"
    f="checked"
    m=0
  else
    m="checked"
    f=0
  end
    
    if afrod=="y"
        afd="checked"
      else
        afd=0
    end
  
  
  edad=edad_anos*12+edad_meses 
  gfrg, equationg, unitsg, name = calculate_gfr_guerbet(edad,sexo,talla,creatinina,afrod) #con las formulas de guerbet
  gfrn, equationn, unitsn = calculate_gfr_nuevo(edad,sexo,talla,creatinina,afrod) #con las formulas recomendadas por la  ACR
  gfro, equationo, unitso = calculate_gfr(edad,sexo,peso,talla,creatinina) #con las formulas antiguas
  
  if gfrg>30 && gfrg<59 && edad_anos>18
    mostrar="1"
    body = erb(:email, layout: false , :locals => { :gfrg => gfrg})
    require 'pony'
     Pony.mail({
        :to => 'arango8316@gmail.com',
        :subject => "Paciente candidato para el Protocolo de Guerbet",
        :body => body,
        :via => :smtp,
        :via_options => {
         :address              => 'smtp.gmail.com',
         :port                 => '587',
         :enable_starttls_auto => true,
         :user_name            => 'alertasiatm@gmail.com',
         :password             => 'Iatm2012',
         :authentication       => :plain, 
         :domain               => "localhost.localdomain" 
         }
        })
  end
  
  
  
  erb:resultstfgn, :locals => {:tfgn =>gfrn, :equationn=> equationn, :unitsn=>unitsn,:tfgg =>gfrg, :equationg=> equationg, :unitsg=>unitsg,:name=>name,:tfgo =>gfro, :equationo=> equationo,:unitso=>unitso,:edad=>edad,:peso=>peso,:anios=>edad_anos,:meses=>edad_meses,:female=>f,:male=>m,:talla=>talla,:creatinina=>creatinina,:afrod=>afd,:date=>date,:nombre=>nombre,:id=>id,:mostrar=>mostrar}
  

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

def mdrd(edad_meses,sexo,creatinina,afrod) # La nueva de adultos recomendada por la NKF (mayores de 18)
	edad = edad_meses/12
  if afrod=='y'
      k=1.212
      else
	      if sexo == 'F'
		      k=0.742
	      else
		      k=1
	      end
  end
	mdr=creatinina**-1.154
  mdr=mdr*edad** -0.203
	#gfr=
  175*mdr*k
  #equation= 'MDRD'
  #output=[gfr, equation]
end
     
def schwartzg(sexo, edad_meses, talla, creatinina) # Schawartz recomendada por Guerbet
	k = case edad_meses
			when 0..3 then 29
			when 4..12 then 40
			when 13..144 then 49
			when 145..252
				if sexo == 'F'
					53
				else
					62
				end
			else
				puts "Hubo un error al calcular la TGF con la formula de Schwartz"
			end
  creatinina_uml=creatinina*88 #conversion a umol/L
  talla*k / creatinina_uml
  #equation='Schwartz'
  #output=[gfr, equation]
end


def mder(edad_meses,sexo,creatinina,afrod) #Para adultos recomendada por Guerbet 
	edad = edad_meses/12
    if afrod=='y'
        k=1.212
        else
            if sexo == 'F'
                k=0.742
                else
                k=1
                end
        end
	mdr=creatinina**-1.154
    mdr=mdr*edad** -0.203
	#gfr=
  186*mdr*k
  #equation= 'MDRD'
  #output=[gfr, equation]
end

def calculate_gfr(edad_meses,sexo,peso,talla,creatinina) # Con las formulas viejas que estamos usando
	edad = edad_meses/12
  units="ml/min"
	if edad > 21
		puts "Usando la formula de Cockroft-Gault..."
		puts "Edad: #{edad}, Sexo: #{sexo}, Peso: #{peso}, Creatinina: #{creatinina}"
    gfr=cockroft(sexo, edad, peso, creatinina)
		equation = "Cockroft-Gault"
    return [gfr,equation,units]
	else
		puts "Usando la formula de Schwartz..."
		puts "Edad (en meses): #{edad_meses}, Sexo: #{sexo}, Talla: #{talla}, Creatinina: #{creatinina}"
    gfr=schwartz(sexo, edad_meses, talla, creatinina)
		equation = "Schwartz"
    return [gfr,equation,units]
	end
end

def calculate_gfr_nuevo(edad_meses,sexo,talla,creatinina,afrod) # Con las formulas nuevas, recomendadas por la ACR
	edad = edad_meses/12

	if edad > 18
		puts "Usando la formula de MDRD..."
		puts "Edad: #{edad}, Sexo: #{sexo}, Creatinina: #{creatinina}"
                equation="MDRD"
		gfr=mdrd(edad_meses,sexo,creatinina,afrod)
	else
		puts "Usando la formula de Bedside Schwartz..."
		puts "Talla: #{talla}, Creatinina: #{creatinina}"
		gfr=bedside_schwartz(talla, creatinina)
                equation="Bedside Schwartz"
	end
 units= "ml/min/1.73 m2"
        return [gfr,equation,units]
end

def calculate_gfr_guerbet(edad_meses,sexo,talla,creatinina,afrod) # Con las formulas nuevas, recomendadas por Guerbet
	edad = edad_meses/12

	if edad > 18
		puts "Usando la formula de MDER..."
		puts "Edad: #{edad}, Sexo: #{sexo}, Creatinina: #{creatinina}"
                equationn="MDER"
                units="ml/min/1.73m2"
                name="Tasa de filtracion glomerular estimada"
		gfr=mder(edad_meses,sexo,creatinina,afrod)
    
  else
  		puts "Usando la formula de Schwartz..."
  		puts "Edad (en meses): #{edad_meses}, Sexo: #{sexo}, Talla: #{talla}, Creatinina: #{creatinina}"
      gfr=schwartzg(sexo, edad_meses, talla, creatinina)
  		equationn = "Schwartz"
      units="ml/min"
      name="Aclaramiento de creatinina estimado"
    end
        return [gfr,equationn,units,name]
end
