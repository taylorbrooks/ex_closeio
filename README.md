ExCloseio
========
[![Hex.pm](https://img.shields.io/hexpm/v/ex_closeio.svg)](https://hex.pm/packages/ex_closeio)

## Installation

ExCloseio is currently beta software. You can install it from Hex:

```elixir
def deps do
  [ {:ex_closeio, "~> 0.0.1"} ]
end
```

## Configuration

For security, I recommend that you use environment variables for storing
your account credentials. If you don't already have an environment
variable manager, you can create a `.env` file in your project with the
following content:

```bash
export CLOSEIO_API_KEY={{ your api key }}
```

Then, just be sure to run `source .env` in your shell before compiling your
project.

Alternatively, you can set the following configuration variables in your
`config/config.exs` file:

```elixir
config :ex_closeio, closeio_api_key: System.get_env("CLOSEIO_API_KEY"),
```

Or you can pass the API key in with each request:

```elixir
ExCloseio.Lead.find("lead_id_1234", "api_key_5678")
```

## Usage

ExCloseio comes with module for each supported Close.io API resource. For example,
the "Lead" resource is accessible through the `ExCloseio.Lead` module. Depending
on what the underlying API supports, a resource module may have the following
methods:

| Method            | Description                                                       |
| ----------------- | ----------------------------------------------------------------- |
| **all**           | Get the first page of the resource.                               |
| **paginate**      | Load all of the resource items on all pages. Use with care!       |
| **find**          | Find a resource given its id.                                     |
| **create**        | Create a resource.                                                |
| **update**        | Update a resource.                                                |
| **destroy**       | Destroy a resource.                                               |

### Supported Endpoints

ExCloseio currently supports the following Closeio endpoints:

- [Contact](http://developer.close.io/#Contacts).
- [CustomField](http://developer.close.io/#Custom-Fields)
- [EmailTemplate](http://developer.close.io/#Email-Templates)
- [Lead](http://developer.close.io/#Leads)
- [LeadStatus](http://developer.close.io/#Lead-Statuses)
- [Opportunity](http://developer.close.io/#Opportunities)
- [OpportunityStatus](http://developer.close.io/#Opportunity-Statuses)
- [Organization](http://developer.close.io/#Organizations)
- [SmartView](http://developer.close.io/#Smart-Views)
- [Task](http://developer.close.io/#Tasks)
- [User](http://developer.close.io/#Users)

### Example

```elixir
# Get all the leads in the Lead endpoint. Be warned, this will block
# until all the pages of leads have been fetched.
leads = ExCloseio.Lead.paginate(
  %{query: "custom.current_system:paypal"},
  API_KEY
)

# Get the first page. The meta variable is a map of paging information
# from Close.io.
{:ok, leads} = ExCloseio.Lead.all

# Find a lead
{:ok, lead} = ExCloseio.Lead.find("lead_id_1234")

# Update a lead
lead = ExCloseio.Lead.update(lead, status: "cancelled")

# Destroy a lead
ExCloseio.Lead.destroy("lead_id_1234")
```

## License
ExCloseio is licensed under the MIT license. For more details, see the `LICENSE`
file at the root of the repository. It depends on Elixir, which is under the
Apache 2 license.

Closeio<sup>TM</sup> is trademark of Elastic, Inc.

[hex]: http://hex.pm
