alias g := generate

generate:
  sourcery --sources Sources/Prelude --templates Templates/Alt.swifttemplate --output Sources/Prelude        
  sourcery --sources Sources/Prelude --templates Templates/Applicative.swifttemplate --output Sources/Prelude
  sourcery --sources Sources/Prelude --templates Templates/Apply.swifttemplate --output Sources/Prelude      
  sourcery --sources Sources/Prelude --templates Templates/Bind.swifttemplate --output Sources/Prelude       
  sourcery --sources Sources/Prelude --templates Templates/Either.swifttemplate --output Sources/Prelude     
  sourcery --sources Sources/Prelude --templates Templates/Functor.swifttemplate --output Sources/Prelude    
  sourcery --sources Sources/Prelude --templates Templates/Monad.swifttemplate --output Sources/Prelude      
