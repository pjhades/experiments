use serde::de::{self, DeserializeSeed, EnumAccess, VariantAccess, Visitor};
use serde::{Deserialize, Deserializer, Serialize};
use std::fmt::{self, Display};

// Define our own custom error type.
#[derive(Debug, PartialEq)]
enum Error {
    Invalid(String),
}

// Implement this trait to use our custom error together with serde.
impl de::Error for Error {
    fn custom<T>(msg: T) -> Self
    where
        T: Display,
    {
        Self::Invalid(msg.to_string())
    }
}

// Satisfy the bound: std::error::Error needs to be Debug + Display.
impl Display for Error {
    fn fmt(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            Self::Invalid(ref s) => write!(formatter, "{}", s),
        }
    }
}

// Same as above.
impl std::error::Error for Error {}

// Here's the data structure into which we want to deserialize the input.
// We derive `Deserialize` to let serde work out the `deserialize` method,
// which will call the vairous `deserialize_xyz` methods from `Deserializer` trait.
#[derive(Serialize, Deserialize, Debug, PartialEq)]
enum Number {
    One,
    Two,
    Three,
}

// Define a struct to implement the `Deserializer` trait.
// This struct maintains whatever states we need during the deserialization.
// Here the only state we need is the input integer.
struct NumberDeserializer(u64);

// Implement the `Deserializer` trait for a reference, because
// later we'll pass the reference to `Enum`. See below.
impl<'de, 'a> Deserializer<'de> for &'a NumberDeserializer {
    type Error = Error;

    // Most of these `deserialize_xyz` methods will simply return an error,
    // because our data structure is an enum, so all these methods are irrelevant
    // and their corresponding types are forwarded to this method.
    fn deserialize_any<V>(self, _visitor: V) -> Result<V::Value, Self::Error>
    where
        V: Visitor<'de>,
    {
        Err(Error::Invalid("type error".to_string()))
    }

    // Now this is the `deserialize_xyz` that will be called from the
    // `deserialize` method from the derived `Deserialize` implementation.
    // In our case, `name` will actually be "Number" and `variants` will be
    // &["One", "Two", "Three"].
    //
    // We call the `visit_enum` method from the visitor, because we need to
    // return an enum, that is our data structure, the result of deserialization.
    //
    // What we pass to the visitor is an `Enum`, which implements `EnumAccess`,
    // to help the visitor figure our the elements of the enum: variant name, variant
    // value etc.
    fn deserialize_enum<V>(
        self,
        _name: &'static str,
        _variants: &'static [&'static str],
        visitor: V,
    ) -> Result<V::Value, Self::Error>
    where
        V: Visitor<'de>,
    {
        visitor.visit_enum(Enum { de: &self })
    }

    // This will be called from the `deserialize` method of `EnumAccess`,
    // because usually an enum would expect an identifier for its variants.
    // However here our input is just an integer. This integer is stored
    // on `self`, so we look at it an figure out which variant we want as
    // the output.
    fn deserialize_identifier<V>(self, visitor: V) -> Result<V::Value, Self::Error>
    where
        V: Visitor<'de>,
    {
        visitor.visit_str(match self.0 {
            1 => "One",
            2 => "Two",
            3 => "Three",
            _ => {
                return Err(Error::Invalid("value is not 1, 2 or 3".to_string()));
            }
        })
    }

    serde::forward_to_deserialize_any! {
        bool i8 i16 i32 i64 i128 u8 u16 u32 u64 u128 f32 f64 char str string
        bytes byte_buf option unit unit_struct struct newtype_struct seq tuple
        tuple_struct map ignored_any
    }
}

// A helper struct that implements `EnumAccess` and `VariantAccess`
// in order to help the visitor in `deserialize_enum` above.
struct Enum<'a> {
    de: &'a NumberDeserializer,
}

impl<'de, 'a> EnumAccess<'de> for Enum<'a> {
    type Error = Error;
    type Variant = Self;

    fn variant_seed<V>(self, seed: V) -> Result<(V::Value, Self::Variant), Self::Error>
    where
        V: DeserializeSeed<'de>,
    {
        let val = seed.deserialize(self.de)?;
        Ok((val, self))
    }
}

impl<'de, 'a> VariantAccess<'de> for Enum<'a> {
    type Error = Error;

    // Serde allows different flavors of enum variants.
    // In our case it's the simplest one: a so-called unit variant
    // that has no associated value.
    // Here we don't need to do anything. We have returned the string
    // corresponding to the input integer in the `deserialize_identifier`
    // above, so here we just return OK.
    fn unit_variant(self) -> Result<(), Self::Error> {
        Ok(())
    }

    // The rest are all irrelevent in our case. Our enum variants do
    // not have any associated value.
    fn newtype_variant_seed<T>(self, _seed: T) -> Result<T::Value, Self::Error>
    where
        T: DeserializeSeed<'de>,
    {
        Err(Error::Invalid("newtype variant".to_string()))
    }

    fn tuple_variant<V>(self, _len: usize, _visitor: V) -> Result<V::Value, Self::Error>
    where
        V: Visitor<'de>,
    {
        Err(Error::Invalid("tuple variant".to_string()))
    }

    fn struct_variant<V>(
        self,
        _fields: &'static [&'static str],
        _visitor: V,
    ) -> Result<V::Value, Self::Error>
    where
        V: Visitor<'de>,
    {
        Err(Error::Invalid("struct variant".to_string()))
    }
}

// Now this is our public interface: given an `u64`,
// we return a `Number` that is deserialized from the integer.
fn from_value(x: u64) -> Result<Number, Error> {
    let deserializer = NumberDeserializer(x);
    // Note that we're calling the `deserialize` method from the
    // derived `Deserialize` trait on `Number`.
    Number::deserialize(&deserializer)
}

fn main() {
    for i in 0..10 {
        let x = from_value(i);
        match i {
            1 => assert_eq!(x, Ok(Number::One)),
            2 => assert_eq!(x, Ok(Number::Two)),
            3 => assert_eq!(x, Ok(Number::Three)),
            _ => assert_eq!(x, Err(Error::Invalid("value is not 1, 2 or 3".to_string()))),
        }
    }
}
