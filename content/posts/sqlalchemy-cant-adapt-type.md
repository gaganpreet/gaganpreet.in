---
title: Adapting types to fix SQLAlchemy's "can't adapt type" error
author: gagan
date: 2020-10-21T00:00:00+00:00
categories:
 - programming
tags:
  - python
  - sqlalchemy
  - programmingerror
  - pydantic

---

I have recently been using Pydantic a lot, which is pretty cool since it lets me specify concrete types on my previously untyped data. 

Until I ran into an error when I was inserting data stored in a Pydantic model to my postgres database using SQLAlchemy.

## Problem

I have a Pydantic model like this to define my incoming data from a request:

```python
# Pydantic class
class EventSchema(BaseModel):
    ip_address: IPvAnyAddress
```

Another part in my code defined an SQLAlchemy model to persist this incoming information (along with other data not shown here):

```python
# SQLAlchemy model
class Event(Base):
    __tablename__ = "event"

    id = Column(Integer, primary_key=True)
    ip_address = Column(INET)
```

To convert the data from `EventSchema` to `Event`, I wrote some glue code:

```python
# Glue code
event_data = EventSchema(ip_address="127.0.0.1")
event = Event(**event_data.dict())
```

Unfortunately, this failed with an error when I tried to commit the `event` object to the database.

```sql
sqlalchemy.exc.ProgrammingError: (psycopg2.ProgrammingError) can't adapt type 'IPv4Address'
[SQL: INSERT INTO event (ip_address) VALUES (%(ip_address)s) RETURNING event.id]
[parameters: {'ip_address': IPv4Address('127.0.0.1')}]
(Background on this error at: http://sqlalche.me/e/13/f405)
```

If you visit that link, it's not very helpful. Just a general text about `ProgrammingError` error. Which makes sense if you think about it: it's an error outside of SQLAlchemy's control.

The description is clear however. The `IPv4Address` Pydantic type can't be used as a value in the database.

## Naive solution: Converting the type

While I could always convert the data manually by converting the IPv4Address type manually to a string, I wanted to avoid that. It's an easy solution, but if I came across more Pydantic types that could not be adapted, I'd have to remember to convert each of them manually.

## Better solution: Adapting unknown types

As usual with the SQLAlchemy ecosystem there's an elegant way to achieve this by using the `register_adapter` handler in psycopg2, which in this case is the database adapter used by SQLAlchemy to interface with postgres.

```python
from psycopg2.extensions import register_adapter, AsIs
from pydantic.networks import IPv4Address, IPv6Address

def adapt_pydantic_ip_address(ip):
    return AsIs(repr(ip.exploded))

register_adapter(IPv4Address, adapt_pydantic_ip_address)
register_adapter(IPv6Address, adapt_pydantic_ip_address)
```

I put this code next to where I set up my SQLAlchemy session. But it does not matter where you choose place the adapters.

This turned out to be a very elegant solution since I only have to do it once and forget about having to do it again. Plus I can always adapt more Pydantic types if needed using a similar approach.
