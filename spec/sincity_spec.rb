require "estado"
require "sincity"

describe "sincity" do

  def un_estado_con(viento: 0, nubosidad: 0, estacion: Verano, feriado: false, precio_kw_mundial: 11)
    Estado.new(viento: viento, nubosidad: nubosidad, estacion: estacion, feriado: feriado, precio_kw_mundial: precio_kw_mundial)
  end

  describe "cuando simulamos un día" do

    it "con una planta eólica, la energia producida debe ser el triple de la condicion viento" do
      viento = 15
      ciudad = Ciudad.new
      ciudad.construir(PlantaEolica.new)
      estado = un_estado_con(viento: viento)

      ciudad.simular_dia(estado)

      expect(estado.energia_producida).to be(viento * 3)
    end

    it "con una planta fosil, la energia producida debe ser kw_por_hora * 24hs" do
      nro_empleados = 4
      kws_hora_por_empleado = 2
      ciudad = Ciudad.new
      ciudad.construir(PlantaFosil.new(nro_empleados, kws_hora_por_empleado))
      estado = un_estado_con

      ciudad.simular_dia(estado)

      kw_por_hora = nro_empleados * kws_hora_por_empleado
      expect(estado.energia_producida).to be(kw_por_hora * 24)
    end

    it "con una planta solar, la energia producida debe ser nubosidad * kw_por_hora * horas de sol del verano" do
      nubosidad = 0.2
      kw_por_hora = 3
      ciudad = Ciudad.new
      ciudad.construir(PlantaSolar.new(kw_por_hora, gestion: GestionPublica.new))
      estado = un_estado_con(nubosidad: nubosidad, estacion: Verano, feriado: false)

      ciudad.simular_dia(estado)

      expect(estado.energia_producida).to be(nubosidad * kw_por_hora * Verano.horas_de_sol)
    end

    it "con una planta solar, en un día feriado con gestión pública, produce la mitad de energía" do
      nubosidad = 0.2
      kw_por_hora = 3
      ciudad = Ciudad.new
      ciudad.construir(PlantaSolar.new(kw_por_hora, gestion: GestionPublica.new))
      estado = un_estado_con(nubosidad: nubosidad, estacion: Verano, feriado: true)

      ciudad.simular_dia(estado)

      expect(estado.energia_producida).to be(nubosidad * kw_por_hora * Verano.horas_de_sol / 2)
    end

    it "con una planta solar con gestión privada, siendo el precio mundial kw mayor a 10, produce energía" do
      nubosidad = 0.2
      kw_por_hora = 3
      ciudad = Ciudad.new
      ciudad.construir(PlantaSolar.new(kw_por_hora, gestion: GestionPrivada.new))
      estado = un_estado_con(nubosidad: nubosidad, estacion: Verano, precio_kw_mundial: 11)

      ciudad.simular_dia(estado)

      expect(estado.energia_producida).to be(nubosidad * kw_por_hora * Verano.horas_de_sol)
    end

    it "con una planta solar con gestión privada, siendo el precio mundial kw menos a 10, no produce energía" do
      ciudad = Ciudad.new
      ciudad.construir(PlantaSolar.new(3, gestion: GestionPrivada.new))
      estado = un_estado_con(nubosidad: 0.2, precio_kw_mundial: 10)

      ciudad.simular_dia(estado)

      expect(estado.energia_producida).to eq(0)
    end
  end

end