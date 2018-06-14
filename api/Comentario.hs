{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Comentario where

import Foundation -- 
import Yesod
import Database.Persist.Postgresql
import Data.Text
import Network.HTTP.Types.Status

-- Cadastra 1 Comentario
postComentarioCriarR :: Handler ()
postComentarioCriarR = do
    pers <- requireJsonBody :: Handler Comentario
    pid <- runDB $ insert pers
    addHeader "Access-Control-Allow-Origin" "*"
    sendResponse (object [pack "resp" .= pack ("CREATED " ++ (show $ fromSqlKey pid))]) 


-- Lista todos os Comentarioes
getComentarioListarR :: Handler Value
getComentarioListarR = do
    pers <- runDB $ selectList [] [Asc ComentarioNome]
    addHeader "Access-Control-Allow-Origin" "*"
    sendResponse (object [pack "resp" .= toJSON pers])

-- Recebe 1 Comentario
getComentarioGetR :: ComentarioId -> Handler Value
getComentarioGetR pid = do
    pers <- runDB $ get404 pid
    addHeader "Access-Control-Allow-Origin" "*"
    sendStatusJSON ok200 (object ["resp" .= pers])

-- Deleta 1 Comentario
deleteComentarioDeleteR :: ComentarioId -> Handler Value
deleteComentarioDeleteR pid = do
    _ <- runDB $ get404 pid
    runDB $ delete pid
    addHeader "Access-Control-Allow-Origin" "*"
    sendStatusJSON noContent204 (object [])