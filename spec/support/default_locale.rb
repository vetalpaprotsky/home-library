module DefaultLocale

  LocaleParams = { locale: I18n.default_locale }

  def get(path, params={})
    super path, params.merge(LocaleParams)
  end

  def post(path, params={})
    super path, params.merge(LocaleParams)
  end

  def put(path, params={})
    super path, params.merge(LocaleParams)
  end

  def patch(path, params={})
    super path, params.merge(LocaleParams)
  end

  def delete(path, params={})
    super path, params.merge(LocaleParams)
  end
end
