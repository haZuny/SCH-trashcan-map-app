# from msilib.schema import Shortcut
# from rest_framework import viewsets
# from trash_model.serializers import TrashSerializer
# from trash_model.models import Trash

from typing import ByteString
from django.shortcuts import render
from rest_framework.response import Response
from .models import Trash
from rest_framework.views  import APIView
from .serializers import TrashSerializer
from django.http import Http404

import io   # 이미지 관련
import os
from django.core.files import File
from django.http import FileResponse

# Create your views here.
# class TrashViewSet(viewsets.ModelViewSet):
#     queryset = Trash.objects.all()
#     serializer_class = TrashSerializer


# 전체 게시물
class TrashList(APIView):
    def post(self, request):
        print("포스트")
        serializer = TrashSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors)

    def get(self, request):
        quryset = Trash.objects.all()
        serizer = TrashSerializer(quryset, many=True)

        # 전송할 데이터 가공
        sendData = []
        for obj in serizer.data:
            newObj = {} # 최종적으로 보낼 객체
            imgBin = "" # 이미지 바이너리
            for key, value in obj.items():
                if(key != 'image'):
                    # f = open('.'+obj['image'], 'rb')
                    # newObj[key] = ''+ str(f.read())
                    newObj[key] = value
                # else:
            sendData.append(newObj)
        
        # print(sendData)
        return Response(sendData)
        

# 특정 게시물
class TrashDetail(APIView):
    def get_object(self, pk):
        try:
            return Trash.objects.get(pk=pk)
        except Trash.DoesNotExist:
            raise Http404


    def get(self, request, pk):
        trash = self.get_object(pk)
        seriizer = TrashSerializer(trash)
        
        # 이미지 파일
        imgF = open('.'+seriizer.data['image'], 'rb')

        print(imgF)
        respense = FileResponse(imgF)

        return respense


