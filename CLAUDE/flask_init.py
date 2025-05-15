"""
Инициализация Flask приложения
"""
from flask import Flask
from flask_cors import CORS
from .config import config
from .extensions import db, jwt, migrate, cache


def create_app(config_name='development'):
    """
    Фабрика приложения Flask
    """
    app = Flask(__name__)
    app.config.from_object(config[config_name])

    # Инициализация расширений
    db.init_app(app)
    jwt.init_app(app)
    migrate.init_app(app, db)
    cache.init_app(app)
    CORS(app)

    # Регистрация блюпринтов API
    from .api import auth_bp, portfolio_bp, assets_bp, analysis_bp
    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(portfolio_bp, url_prefix='/api/portfolios')
    app.register_blueprint(assets_bp, url_prefix='/api/assets')
    app.register_blueprint(analysis_bp, url_prefix='/api/analysis')

    # Обработчик ошибок
    @app.errorhandler(404)
    def not_found(error):
        return {'error': 'Not found'}, 404

    @app.errorhandler(500)
    def internal_error(error):
        return {'error': 'Internal server error'}, 500

    return app