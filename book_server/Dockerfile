FROM trestletech/plumber
COPY ./ /app
RUN R -e "install.packages('DMwR')"
CMD ["/app/server.R"]
