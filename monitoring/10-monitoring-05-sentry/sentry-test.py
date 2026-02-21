import sentry_sdk

sentry_sdk.init(
    dsn="https://00e6dcfbc7165fe75140a73f79aa8a0c@o4510922427793408.ingest.de.sentry.io/4510922462593104",
    # Add data like request headers and IP for users,
    # see https://docs.sentry.io/platforms/python/data-management/data-collected/ for more info
    send_default_pii=True,
)

division_by_zero = 1 / 0