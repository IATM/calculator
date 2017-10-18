puts "PROTOCOLO DE URORESONANCIA FUNCIONAL"

puts "Nombre del paciente:"
name=gets.chomp
puts "Edad:"
age=gets.chomp
puts "Peso:"
weigth=gets.chomp

puts "HIDRATACION"
hydration=Integer(weigth)*20
if hydration>1000
    hydration=1000
    end

puts "SSNN o Lactato de Ringer's:#{hydration} ml en una hora"

print "CATERIZACION VESICAL"
size=((Integer(age)/4)+4)*2
puts "Tamanio del cateter French FR:#{size} "

puts "ADMINISTRACION DEL DIURETICO"

dosis=Integer(weigth)

if dosis >20
    dosis=20
end
flow=10

puts "Dosis: #{dosis} mg forma de dosificacion: #{flow} mg/ml [1mg=0.1ml]"

print "ADMINISTRACION DEL CONTRASTE"
gadolinio=0.2 * Integer(weigth)
if gadolinio<2
gadolinio=2
    end
if gadolinio>20
gadolinio=20
end

if Integer(weigth)<=27.5
flowga=0.1
elsif Integer(weigth)<=57.5
flowga=0.15
else
flowga=0.2
end

volume=12

puts "Gadolinio  DTPA [Magnevist (r)] IV #{gadolinio} ml, inyector a flujo de #{flowga} ml/s con #{volume}ml de lavado"