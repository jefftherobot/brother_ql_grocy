FROM python:3.9-alpine as builder

WORKDIR /app

RUN apk add fontconfig build-base libdmtx libdmtx-dev

RUN python3 -m venv /app/.venv
ENV PATH=/app/.venv/bin:$PATH

COPY requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt

FROM python:3.9-alpine

# gcc needed because pythons find_libary doesn't work without it https://bugs.python.org/issue21622
RUN apk add gcc fontconfig freetype ttf-dejavu libdmtx libdmtx-dev

WORKDIR /app

COPY --from=builder /app /app
ENV PATH=/app/.venv/bin:$PATH

COPY . .

EXPOSE 8013

CMD [ "python", "./brother_ql_web.py" ]