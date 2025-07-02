FROM python:3.13.4-alpine3.22

# Define um r�tulo para o mantenedor do Dockerfile (opcional, mas boa pr�tica)
LABEL maintainer="Gemini Code Assist"

# Impede o Python de gravar arquivos .pyc no disco
ENV PYTHONDONTWRITEBYTECODE 1
# Garante que a sa�da do Python seja enviada diretamente para o terminal (sem buffer)
ENV PYTHONUNBUFFERED 1

# Define o diret�rio de trabalho dentro do cont�iner
WORKDIR /app

# Copia o arquivo de depend�ncias para o diret�rio de trabalho
COPY requirements.txt .

# Instala as depend�ncias
RUN pip install --no-cache-dir -r requirements.txt

# Cria um usu�rio n�o-root para executar a aplica��o por seguran�a
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copia o restante do c�digo da aplica��o
COPY . .

# Altera a propriedade dos arquivos para o usu�rio n�o-root
RUN chown -R appuser:appgroup /app

# Muda para o usu�rio n�o-root
USER appuser

# Exp�e a porta em que a aplica��o ser� executada
EXPOSE 8001

# Comando para iniciar a aplica��o quando o cont�iner for executado
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8001", "--reload"]
