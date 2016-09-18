module DefaultLocale

  LOCALE_PARAMS = { locale: I18n.default_locale }

  def get(path, params={})
    super path, params.merge(LOCALE_PARAMS)
  end

  def post(path, params={})
    super path, params.merge(LOCALE_PARAMS)
  end

  def put(path, params={})
    super path, params.merge(LOCALE_PARAMS)
  end

  def patch(path, params={})
    super path, params.merge(LOCALE_PARAMS)
  end

  def delete(path, params={})
    super path, params.merge(LOCALE_PARAMS)
  end
end
