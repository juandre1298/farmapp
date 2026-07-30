# db/seeds.rb

puts "🌱 Seeding database..."

# ------------------------------------------------------------------------------
# 1. USERS
# ------------------------------------------------------------------------------
puts "  -> Creating Users..."

users_data = [
  { first_name: "Admin", last_name: "System", email: "admin@farmapp.com", role: "admin" },
  { first_name: "Juan", last_name: "Pérez", email: "juan.perez@farmapp.com", role: "employee" },
  { first_name: "Maria", last_name: "Gomez", email: "maria.gomez@farmapp.com", role: "employee" },
  { first_name: "Carlos", last_name: "Mendoza", email: "carlos.mendoza@farmapp.com", role: "employee" }
]

users = users_data.map do |data|
  User.find_or_create_by!(email: data[:email]) do |u|
    u.first_name = data[:first_name]
    u.last_name = data[:last_name]
    u.role = data[:role]
  end
end

# ------------------------------------------------------------------------------
# 2. LOCATIONS
# ------------------------------------------------------------------------------
puts "  -> Creating Locations..."

locations_data = [
  { name: "Bodega Principal", address: "Calle 72 # 45-10", city: "Barranquilla", country: "Colombia" },
  { name: "Sucursal Centro", address: "Carrera 43 # 34-02", city: "Barranquilla", country: "Colombia" },
  { name: "Sucursal Norte", address: "Carrera 53 # 82-120", city: "Barranquilla", country: "Colombia" },
  { name: "Sucursal Prado", address: "Calle 58 # 54-20", city: "Barranquilla", country: "Colombia" }
]

locations = locations_data.map do |data|
  Location.find_or_create_by!(name: data[:name]) do |l|
    l.address = data[:address]
    l.city = data[:city]
    l.country = data[:country]
  end
end

# ------------------------------------------------------------------------------
# 3. MEDICINES
# ------------------------------------------------------------------------------
puts "  -> Creating Expanded Medicine Catalog..."

medicines_data = [
  # Analgésicos & Antiinflamatorios
  { name: "Acetaminofén 500mg", description: "Analgésico y antipirético para control de dolor moderado y fiebre", unit_price: 4_000.00, therapeutic_class: "Analgesic" },
  { name: "Ibuprofeno 800mg", description: "Antiinflamatorio no esteroideo (AINE) analgésico", unit_price: 8_500.00, therapeutic_class: "Analgesic" },
  { name: "Naproxeno 500mg", description: "Antiinflamatorio y analgésico de larga duración", unit_price: 11_000.00, therapeutic_class: "Analgesic" },
  { name: "Tramadol 50mg", description: "Analgésico opioide sintético de acción central", unit_price: 28_000.00, therapeutic_class: "Analgesic" },

  # Antibióticos
  { name: "Amoxicilina 500mg", description: "Antibiótico aminopenicilínico de amplio espectro", unit_price: 15_000.00, therapeutic_class: "Antibacterial" },
  { name: "Azitromicina 500mg", description: "Antibiótico macrólido para infecciones respiratorias y cutáneas", unit_price: 24_500.00, therapeutic_class: "Antibacterial" },
  { name: "Ciprofloxacino 500mg", description: "Fluoroquinolona de amplio espectro para infecciones urinarias e intestinales", unit_price: 18_900.00, therapeutic_class: "Antibacterial" },
  { name: "Cefalexina 500mg", description: "Cefalosporina de primera generación", unit_price: 16_200.00, therapeutic_class: "Antibacterial" },

  # Antihipertensivos & Cardiovascular
  { name: "Losartán 50mg", description: "Antihipertensivo antagonista de los receptores de angiotensina II", unit_price: 22_000.00, therapeutic_class: "Antihypertensive" },
  { name: "Enalapril 20mg", description: "Inhibidor de la ECA para tratamiento de hipertensión e insuficiencia cardíaca", unit_price: 9_800.00, therapeutic_class: "Antihypertensive" },
  { name: "Amlodipino 5mg", description: "Bloqueador de canales de calcio para control de presión arterial", unit_price: 14_000.00, therapeutic_class: "Antihypertensive" },
  { name: "Atorvastatina 20mg", description: "Hipolipemiante inhibidor de la HMG-CoA reductasa para colesterol", unit_price: 31_500.00, therapeutic_class: "Antihyperlipidemic" },

  # Gastrointestinal
  { name: "Omeprazol 20mg", description: "Inhibidor de la bomba de protones para reflujo y gastritis", unit_price: 12_300.00, therapeutic_class: "Antiulcer" },
  { name: "Esomeprazol 40mg", description: "Inhibidor de la bomba de protones de alta potencia", unit_price: 38_000.00, therapeutic_class: "Antiulcer" },
  { name: "Metoclopramida 10mg", description: "Antiemético y procinético gastrointestinal", unit_price: 6_500.00, therapeutic_class: "Antiemetic" },

  # Endocrinología / Diabetes
  { name: "Metformina 850mg", description: "Biguanida antihiperglucemiante para Diabetes Mellitus Tipo 2", unit_price: 13_500.00, therapeutic_class: "Antidiabetic" },
  { name: "Glibenclamida 5mg", description: "Sulfonilurea estimulante de la secreción de insulina", unit_price: 7_200.00, therapeutic_class: "Antidiabetic" },

  # Antihistamínicos & Respiratorio
  { name: "Loratadina 10mg", description: "Antihistamínico H1 no sedante para rinitis y alergias", unit_price: 5_500.00, therapeutic_class: "Antihistamine" },
  { name: "Cetirizina 10mg", description: "Antihistamínico de segunda generación para alergias cutáneas y respiratorias", unit_price: 8_900.00, therapeutic_class: "Antihistamine" },
  { name: "Salbutamol Inhalador 100mcg", description: "Broncodilatador agonista beta-2 para asma y broncoespasmo", unit_price: 26_000.00, therapeutic_class: "Bronchodilator" }
]

medicines = medicines_data.map do |data|
  Medicine.find_or_create_by!(name: data[:name]) do |m|
    m.description = data[:description]
    m.unit_price = data[:unit_price]
    m.therapeutic_class = data[:therapeutic_class]
  end
end

# ------------------------------------------------------------------------------
# 4. BATCHES (Lotes de Inventario Distribuidos)
# ------------------------------------------------------------------------------
puts "  -> Creating Batches for All Medicines..."

medicines.each_with_index do |med, index|
  loc = locations[index % locations.size]

  # Lote Principal (Vigente)
  Batch.find_or_create_by!(
    medicine: med,
    location: loc,
    expiration_date: Date.current + (6..24).to_a.sample.months
  ) do |b|
    b.initial_qty = 300
    b.remaining_qty = 300
  end

  # Lote Secundario en otra bodega
  if index < 10
    second_loc = locations[(index + 1) % locations.size]
    Batch.find_or_create_by!(
      medicine: med,
      location: second_loc,
      expiration_date: Date.current + (3..12).to_a.sample.months
    ) do |b|
      b.initial_qty = 150
      b.remaining_qty = 150
    end
  end
end

# ------------------------------------------------------------------------------
# 5. MULTIPLE HISTORICAL INVOICES & INVOICE ITEMS
# ------------------------------------------------------------------------------
puts "  -> Generating Historical Invoices & Descounting Stock..."

employees = users.select { |u| u.role == "employee" }
available_batches = Batch.where("remaining_qty > 20").to_a

# Creamos 18 facturas históricas simuladas en los últimos 30 días
if Invoice.count < 5
  18.times do |i|
    Invoice.transaction do
      # Seleccionamos un cajero aleatorio y una fecha en los últimos 30 días
      cajero = employees.sample
      days_ago = rand(0..30)
      created_date = days_ago.days.ago

      # Tomamos entre 1 y 4 lotes aleatorios para esta factura
      sampled_batches = available_batches.sample(rand(1..4))
      total_invoice_amount = 0

      # Instanciamos la factura sin guardar
      invoice = Invoice.new(
        user: cajero,
        total_amount: 0,
        created_at: created_date,
        updated_at: created_date
      )

      sampled_batches.each do |batch|
        quantity_sold = rand(1..5)
        price_at_sale = batch.medicine.unit_price

        # Verificamos disponibilidad de stock
        next if batch.remaining_qty < quantity_sold

        # Descontamos del lote
        batch.remaining_qty -= quantity_sold
        batch.save!

        # Construimos el renglón
        invoice.invoice_items.build(
          batch: batch,
          quantity: quantity_sold,
          unit_price_at_sale: price_at_sale,
          created_at: created_date,
          updated_at: created_date
        )

        total_invoice_amount += (quantity_sold * price_at_sale)
      end

      # Si la factura acumuló items, la guardamos
      if invoice.invoice_items.any?
        invoice.total_amount = total_invoice_amount
        invoice.save!
      end
    end
  end
end

puts "✅ Database successfully seeded!"
puts "   Users: #{User.count}"
puts "   Locations: #{Location.count}"
puts "   Medicines: #{Medicine.count}"
puts "   Batches: #{Batch.count}"
puts "   Invoices: #{Invoice.count}"
puts "   InvoiceItems: #{InvoiceItem.count}"
