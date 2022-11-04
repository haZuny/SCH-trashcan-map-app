# from msilib.schema import Shortcut
# from rest_framework import viewsets
# from trash_model.serializers import TrashSerializer
# from trash_model.models import Trash

from django.shortcuts import render
from rest_framework.response import Response
from .models import Trash
from rest_framework.views  import APIView
from .serializers import TrashSerializer
from django.http import Http404

# Create your views here.
# class TrashViewSet(viewsets.ModelViewSet):
#     queryset = Trash.objects.all()
#     serializer_class = TrashSerializer


# 전체 게시물
class TrashList(APIView):
    def post(self, request):
        serializer = TrashSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors)

    def get(self, request):
        quryset = Trash.objects.all()
        serizer = TrashSerializer(quryset, many=True)
        print('출력')
        print(serizer.data)
        return Response(serizer.data)
        

# 특정 게시물
class TrashDetail(APIView):
    def get_object(self, pk):
        try:
            return Trash.objects.get(pk=pk)
        except Trash.DoesNotExist:
            raise Http404

