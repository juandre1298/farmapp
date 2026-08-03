# app/queries/invoices_query.rb
class InvoicesQuery
  DEFAULT_PER_PAGE = 10
  DEFAULT_PAGE = 1
  DEFAULT_ORDER_DIR = "desc".freeze

  def self.call(params = {})
    new(params).call
  end

  def initialize(params = {})
    @params = params
    @relation = Invoice.includes(invoice_items: { batch: :medicine })
  end

  def call
    filter_by_user
    filter_by_date_range
    order_records
    paginate_records
  end

  private

  attr_reader :params, :relation

  def filter_by_user
    return unless params[:user_id].present?

    @relation = relation.where(user_id: params[:user_id])
  end

  def filter_by_date_range
    start_date = parse_date(params[:start_date])
    end_date = parse_date(params[:end_date])

    if start_date && end_date
      # Rango completo desde el inicio de start_date hasta el final de end_date
      @relation = relation.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    elsif start_date
      @relation = relation.where("created_at >= ?", start_date.beginning_of_day)
    elsif end_date
      @relation = relation.where("created_at <= ?", end_date.end_of_day)
    end
  end

  def order_records
    direction = params[:order_dir].to_s.downcase == "asc" ? "asc" : DEFAULT_ORDER_DIR
    @relation = relation.order(created_at: direction)
  end

  def paginate_records
    page = [ params[:page].to_i, DEFAULT_PAGE ].max
    per_page = [ params[:per_page].to_i, DEFAULT_PER_PAGE ].max

    # Ejecuta el conteo total considerando los filtros activos
    total_count = relation.except(:include, :order).count
    total_pages = (total_count.to_f / per_page).ceil

    offset = (page - 1) * per_page
    paginated_records = relation.limit(per_page).offset(offset)

    {
      records: paginated_records,
      meta: {
        current_page: page,
        per_page: per_page,
        total_pages: total_pages,
        total_count: total_count
      }
    }
  end

  def parse_date(date_str)
    return nil if date_str.blank?

    Date.parse(date_str.to_s)
  rescue ArgumentError
    nil
  end
end
