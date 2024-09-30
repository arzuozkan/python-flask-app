# Python 3.9 slim tabanlı bir imaj kullanıyoruz
FROM python:3.9-slim

# Çalışma dizinini /app olarak belirliyoruz
WORKDIR /app

# Gereksinim dosyasını kopyalayıp bağımlılıkları yüklüyoruz
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Uygulama dosyalarını kopyalıyoruz
COPY . .

# Uygulamayı çalıştırıyoruz
CMD ["python", "app.py"]
