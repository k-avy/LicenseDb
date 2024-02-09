# SPDX-FileCopyrightText: 2023 Kavya Shukla <kavyuushukla@gmail.com>
# SPDX-License-Identifier: GPL-2.0-only

FROM golang:1.19 AS build-stage

WORKDIR /LicenseDb

COPY go.mod go.mod
COPY cmd/ cmd/
COPY pkg/ pkg/
COPY docs/ docs/
COPY go.sum go.sum
COPY .env .env

RUN CGO_ENABLED=0 GOOS=linux go build -a -o laas ./cmd/laas

FROM gcr.io/distroless/base-debian11 AS build-release-stage

WORKDIR /

COPY --from=build-stage /LicenseDb/laas ./laas
COPY --from=build-stage /LicenseDb/.env ./.env

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT [ "./laas" ]
