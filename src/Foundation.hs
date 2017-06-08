{-# LANGUAGE OverloadedStrings, TypeFamilies, QuasiQuotes,
             TemplateHaskell, GADTs, FlexibleContexts,
             MultiParamTypeClasses, DeriveDataTypeable,
             GeneralizedNewtypeDeriving, ViewPatterns #-}
module Foundation where
import Yesod
import Yesod.Static
import Data.Text
import Data.Time.Clock
import Database.Persist.Postgresql
    ( ConnectionPool, SqlBackend, runSqlPool, runMigration )

data Sitio = Sitio {getStatic :: Static, connPool :: ConnectionPool }

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|

Sala
  numero Text sqltype=varchar(3)
  desc Text
  deriving Show

Professor
  nome Text
  nome_exibe Text
  deriving Show
  
Usuario
  nome  Text
  email Text
  senha Text
  UniqueEmail email

--Recurso
--  nome Text
--  desc Text

Disciplina
  sigla     Text sqltype=varchar(15)
  descricao Text
  curso     Text sqltype=varchar(5)

Horario
  periodo     Text sqltype=varchar(2)
  disciplina  DisciplinaId
  prof        ProfessorId
  curso       Text sqltype=varchar(5)
  sala        SalaId
    
|]

staticFiles "static"

mkYesodData "Sitio" $(parseRoutesFile "config/routes")

mkMessage "Sitio" "messages" "pt-BR"

instance YesodPersist Sitio where
   type YesodPersistBackend Sitio = SqlBackend
   runDB f = do
       master <- getYesod
       let pool = connPool master
       runSqlPool f pool

instance Yesod Sitio where
    authRoute _ = Just LoginR
    isAuthorized LoginR _ = return Authorized
    isAuthorized AdminR _ = return Authorized
    isAuthorized UsuarioR _ = isAdmin
    isAuthorized AdminR _ = isAdmin
    isAuthorized _ _ = isUser

isAdmin = do
    mu <- lookupSession "_USER"
    return $ case mu of
        Nothing -> AuthenticationRequired
        Just "admin" -> Authorized
        Just _ -> Unauthorized "Soh o admin acessa aqui!"

isUser = do
    mu <- lookupSession "_USER"
    return $ case mu of
        Nothing -> AuthenticationRequired
        Just _ ->  Authorized

type Form a = Html -> MForm Handler (FormResult a, Widget)

instance RenderMessage Sitio FormMessage where
    renderMessage _ _ = defaultFormMessage

widgetForm :: Route Sitio -> Enctype -> Widget -> Text -> Widget
widgetForm x enctype widget y = $(whamletFile "templates/form.hamlet")






