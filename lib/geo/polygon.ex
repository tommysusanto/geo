defmodule Geo.Polygon do

  @moduledoc """
  Defines the Polygon struct. Implements the Ecto.Type behaviour
  """

  @type t :: %Geo.Polygon{ coordinates: [[{number, number}]], srid: integer }
  defstruct coordinates: [], srid: nil

  if Code.ensure_loaded?(Ecto.Type) do
    @behaviour Ecto.Type

    def type, do: :geometry

    def blank?(_), do: false

    def load(%Geo.Polygon{} = polygon), do: {:ok, polygon}
    def load(_), do: :error

    def dump(%Geo.Polygon{} = polygon), do: {:ok, polygon}
    def dump(_), do: :error

    def cast(%Geo.Polygon{} = polygon), do: {:ok, polygon}
    def cast(%{"type" => _, "coordinates" => _} = polygon), do: { :ok, Geo.JSON.decode(polygon) }

    if Code.ensure_loaded?(Poison) do
      def cast(polygon) when is_binary(polygon), do: { :ok, Poison.decode!(polygon) |> Geo.JSON.decode }
    end

    def cast(_), do: :error
  end

end
