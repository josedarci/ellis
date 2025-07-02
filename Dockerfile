FROM python:3.13.4-alpine3.22

# Define um rótulo para o mantenedor do Dockerfile (opcional, mas boa prática)
LABEL maintainer="Gemini Code Assist"

# Impede o Python de gravar arquivos .pyc no disco
ENV PYTHONDONTWRITEBYTECODE 1
# Garante que a saída do Python seja enviada diretamente para o terminal (sem buffer)
ENV PYTHONUNBUFFERED 1

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia o arquivo de dependências para o diretório de trabalho
COPY requirements.txt .

# Instala as dependências
RUN pip install --no-cache-dir -r requirements.txt

# Cria um usuário não-root para executar a aplicação por segurança
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copia o restante do código da aplicação
COPY . .

# Altera a propriedade dos arquivos para o usuário não-root
RUN chown -R appuser:appgroup /app

# Muda para o usuário não-root
USER appuser

# Expõe a porta em que a aplicação será executada
EXPOSE 8001

# Comando para iniciar a aplicação quando o contêiner for executado
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8001", "--reload"]
