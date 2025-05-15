-- Таблица пользователей
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Таблица портфелей
CREATE TABLE portfolios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Таблица активов (акции, облигации и т.д.)
CREATE TABLE assets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ticker VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    asset_type ENUM('stock', 'bond', 'etf', 'other') NOT NULL,
    currency VARCHAR(10) NOT NULL,
    exchange VARCHAR(50),
    sector VARCHAR(100),
    industry VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Таблица транзакций (покупка/продажа активов)
CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    portfolio_id INT NOT NULL,
    asset_id INT NOT NULL,
    transaction_type ENUM('buy', 'sell') NOT NULL,
    quantity DECIMAL(15, 6) NOT NULL,
    price DECIMAL(15, 6) NOT NULL,
    fee DECIMAL(15, 6) DEFAULT 0,
    transaction_date TIMESTAMP NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (portfolio_id) REFERENCES portfolios(id) ON DELETE CASCADE,
    FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE RESTRICT
);

-- Таблица дневных цен активов
CREATE TABLE asset_prices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    asset_id INT NOT NULL,
    date DATE NOT NULL,
    open DECIMAL(15, 6),
    high DECIMAL(15, 6),
    low DECIMAL(15, 6),
    close DECIMAL(15, 6) NOT NULL,
    volume BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE CASCADE,
    UNIQUE KEY (asset_id, date)
);

-- Таблица мультипликаторов активов
CREATE TABLE asset_metrics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    asset_id INT NOT NULL,
    date DATE NOT NULL,
    pe_ratio DECIMAL(15, 6),
    pb_ratio DECIMAL(15, 6),
    dividend_yield DECIMAL(10, 6),
    market_cap DECIMAL(20, 2),
    eps DECIMAL(15, 6),
    revenue DECIMAL(20, 2),
    profit_margin DECIMAL(10, 6),
    debt_to_equity DECIMAL(15, 6),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE CASCADE,
    UNIQUE KEY (asset_id, date)
);

-- Таблица дивидендов
CREATE TABLE dividends (
    id INT AUTO_INCREMENT PRIMARY KEY,
    asset_id INT NOT NULL,
    ex_date DATE NOT NULL,
    payment_date DATE,
    amount DECIMAL(15, 6) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE CASCADE
);

-- Таблица для AI-анализа портфелей
CREATE TABLE portfolio_analysis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    portfolio_id INT NOT NULL,
    analysis_date TIMESTAMP NOT NULL,
    risk_score DECIMAL(5, 2),
    diversification_score DECIMAL(5, 2),
    expected_return DECIMAL(10, 6),
    recommendations TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (portfolio_id) REFERENCES portfolios(id) ON DELETE CASCADE
);